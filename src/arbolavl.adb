with dstack;
package body arbolavl is

   type modo is (insert_mode,remove_mode);

   procedure avacio(a: out avltree) is
   begin
      a.raiz := null;
   end avacio;

   ---------------------------------------------------------------------------------------------------
   procedure poner_1(a: in out avltree; k: in clau; x: in element) is
      --  PROCEDIMIENTOS AUXILIARES:
      --      + poner(pnodo)
      --      + bal_izq
      
      procedure rebal_izq(p: in out pnodo; h: in out boolean; m: in modo) is
         a       : pnodo; 
         b       : pnodo; 
         c, b2   : pnodo; 
         c1, c2  : pnodo; 
      begin
         a:= p; b:= a.iz;
         if b.bl<=0 then 
            b2:= b.der; 
            a.iz:= b2; b.der:=a; p:= b; 
            if b.bl=0 then 
               a.bl:= -1; b.bl:= 1;
               if m=remove_mode then h:= false; end if ; 
            else 
               a.bl:= 0; b.bl:= 0;
               if m=insert_mode then h:= false; end if ; -- else h se mantiene a true
            end if ;
         else -- promociona c
            c:= b.der; c1:= c.iz; c2:= c.der; -- asigna nombres
            b.der:= c1; a.iz:= c2; c.iz:= b; c.der:= a; p:= c; -- reestructura
            if c.bl<=0 then b.bl:= 0; else b.bl:=-1; end if ; -- actualiza bl y h
            if c.bl>=0 then a.bl:= 0; else a.bl:= 1; end if ;
            c.bl:= 0;
            if m=insert_mode then h:= false; end if ; -- else h se mantiene a true
         end if ;
      end rebal_izq;
      
   ---------------------------------------------------------------------------------------------------

      procedure rebal_der(p: in out pnodo; h: in out boolean; m: in modo) is
            -- O p.lc ha crecido en altura un nivel (por inserción) o p.rc ha decrecido un nivel (por borrado)
         a: pnodo; -- el nodo inicialmente en la raiz
         b: pnodo; -- hijo der de a
         c, b2: pnodo; -- hijo izq de b
         c1, c2: pnodo; -- hijos izq y der de c
      begin
         a:= p; b:= a.der;
         if b.bl>=0 then -- promociona
            b2:= b.iz; -- asigna nombre
            a.der:= b2;
            b.iz:=a;
            p:= b; -- reestructura
            if b.bl=0 then -- actualiza bl y h
               a.bl:= 1;
               b.bl:= -1;
               if m=remove_mode then h:= false; end if ; -- else h se mantiene a true
            else -- b.bl= -1
               a.bl:= 0; b.bl:= 0;
               if m=insert_mode then h:= false; end if ; -- else h se mantiene a true
         end if;
         else -- promociona c
            c:= b.iz;
            c1:= c.iz;
            c2:= c.der; -- asigna nombres
            b.iz:= c2;
            a.der:= c1;
            c.iz:= a;
            c.der:= b;
            p:= c; -- reestructura
            if c.bl>=0 then
               b.bl:= 0;
            else
               b.bl:=1;
            end if ; -- actualiza bl y h
            if c.bl<=0 then
               a.bl:= 0;
            else
               a.bl:= -1;
            end if ;
            c.bl:= 0;
            if m=insert_mode then
               h:= false;
            end if ; -- else h se mantiene a true
         end if ;
      end rebal_der;
      
   ---------------------------------------------------------------------------------------------------

      procedure bal_izq(p: in out pnodo; h: in out boolean; m: in modo) is
      begin
         if p.bl = 1 then
            p.bl := 0;
            if m = insert_mode then h:=false; end if;
         elsif p.bl = 0 then
            p.bl := -1;
            if m = remove_mode then h:=false; end if;
         else
            rebal_izq(p,h,m);
         end if;
      end bal_izq;
      
   ---------------------------------------------------------------------------------------------------

      
      procedure bal_der(p: in out pnodo; h: in out boolean; m: in modo) is
      begin
         if p.bl = -1 then
            p.bl := 0;
            if m = insert_mode then h:=false; end if;
         elsif p.bl = 0 then
            p.bl := 1;
            if m = remove_mode then h:=false; end if;
         else        -- bl=1
            rebal_der(p,h,m);
         end if;
      end bal_der;
     
   ---------------------------------------------------------------------------------------------------

      procedure poner_2(p: in out pnodo; k: in clau; x: in element; change: out boolean) is
      begin
         if p = null then                                    -- LA RAÍZ DEL ARBOL ES NULL, CREAMOS LA RAIZ
            p:=new nodo; p.all:=(x,k,0,null,null);
            change:= true;                                   -- HA HABIDO CAMBIOS, ASÍ QUE PONEMOS EL BOOLEANO A TRUE
         else
            if k < p.k then
               poner_2(p.iz,k,x,change);
               if change then
                  bal_izq(p,change,insert_mode);
               end if;
            elsif k > p.k then
               poner_2(p.der,k,x,change);
               if change then bal_der(p,change,insert_mode); end if;
            else
               raise ya_existe;
            end if;
         end if;
      exception
         when storage_error => raise overflow;
      end poner_2;


      --  VARIABLES:
      changes: boolean;
   begin
      poner_2(a.raiz,k,x,changes);
   end poner_1;
   
   ---------------------------------------------------------------------------------------------------


   procedure borrar(a: in out avltree; k: in clau) is
      -- PROCEDIMIENTOS AUXILIARES
      --  + borrar(pnodo)
      procedure rebal_izq(p: in out pnodo; h: in out boolean; m: in modo) is
         a       : pnodo; 
         b       : pnodo; 
         c, b2   : pnodo; 
         c1, c2  : pnodo; 
      begin
         a:= p; b:= a.iz;
         if b.bl<=0 then 
            b2:= b.der; 
            a.iz:= b2; b.der:=a; p:= b; 
            if b.bl=0 then 
               a.bl:= -1; b.bl:= 1;
               if m=remove_mode then h:= false; end if ; 
            else 
               a.bl:= 0; b.bl:= 0;
               if m=insert_mode then h:= false; end if ; -- else h se mantiene a true
            end if ;
         else -- promociona c
            c:= b.der; c1:= c.iz; c2:= c.iz; -- asigna nombres
            b.der:= c1; a.iz:= c2; c.iz:= b; c.der:= a; p:= c; -- reestructura
            if c.bl<=0 then b.bl:= 0; else b.bl:=-1; end if ; -- actualiza bl y h
            if c.bl>=0 then a.bl:= 0; else a.bl:= 1; end if ;
            c.bl:= 0;
            if m=insert_mode then h:= false; end if ; -- else h se mantiene a true
         end if ;
      end rebal_izq;
      
   ---------------------------------------------------------------------------------------------------

      procedure rebal_der(p: in out pnodo; h: in out boolean; m: in modo) is
         a       : pnodo; 
         b       : pnodo; 
         c, b2   : pnodo; 
         c1, c2  : pnodo; 
      begin
         a:= p; b:= a.der;
         if b.bl>=0 then 
            b2:= b.iz; 
            a.der:= b2; b.iz:=a; p:= b; 
            if b.bl=0 then 
               a.bl:= 1; b.bl:= -1;
               if m=remove_mode then h:= false; end if ; 
            else 
               a.bl:= 0; b.bl:= 0;
               if m=insert_mode then h:= false; end if ; -- else h se mantiene a true
            end if ;
         else -- promociona c
            c:= b.iz; c1:= c.der; c2:= c.iz; -- asigna nombres
            b.iz:= c1; a.der:= c2; c.der:= b; c.iz:= a; p:= c; -- reestructura
            if c.bl>=0 then b.bl:= 0; else b.bl:=1; end if ; -- actualiza bl y h
            if c.bl<=0 then a.bl:= 0; else a.bl:= -1; end if ;
            c.bl:= 0;
            if m=insert_mode then h:= false; end if ; -- else h se mantiene a true
         end if ;
      end rebal_der;
      
   ---------------------------------------------------------------------------------------------------

      procedure bal_izq(p: in out pnodo; h: in out boolean; m: in modo) is
      begin
         if p.bl = 1 then
            p.bl := 0;
            if m = insert_mode then h:=false; end if;
         elsif p.bl = 0 then
            p.bl := -1;
            if m = remove_mode then h:=false; end if;
         else
            rebal_izq(p,h,m);
         end if;
      end bal_izq;
      
   ---------------------------------------------------------------------------------------------------

      procedure bal_der(p: in out pnodo; h: in out boolean; m: in modo) is
      begin
         if p.bl = -1 then
            p.bl := 0;
            if m = insert_mode then h:=false; end if;
         elsif p.bl = 0 then
            p.bl := 1;
            if m = remove_mode then h:=false; end if;
         else        -- bl=1
            rebal_der(p,h,m);
         end if;
      end bal_der;
      
   ---------------------------------------------------------------------------------------------------

      
      procedure borrado_masbajo(p: in out pnodo; masbajo: out pnodo; m: in modo; changes : out boolean) is
      begin
         if p.iz /= null then 
            borrado_masbajo(p.iz, masbajo, m, changes);
         end if;
         if changes then bal_der(p, changes, remove_mode);
         else
            masbajo := p; p := p.der; changes := true;
         end if;
      end borrado_masbajo;
      
   ---------------------------------------------------------------------------------------------------

      
      procedure borrado_real(p: in out pnodo; changes: out boolean) is
         masbajo: pnodo;
      begin
         if p.iz = null and p.der = null then
            p := null; changes := true;
         elsif p.iz = null and p.der /= null then
            p := p.der; changes := true;
         elsif p.iz /= null and p.der = null then
            p := p.iz; changes := true;
         else
            borrado_masbajo(p.der, masbajo, remove_mode, changes);
            masbajo.iz := p.iz; masbajo.der := p.der; masbajo.bl := p.bl;
            p := masbajo;
            if changes then bal_izq(p, changes, remove_mode); end if;
         end if;
      end borrado_real;

    
   ---------------------------------------------------------------------------------------------------

      procedure borrar(p: in out pnodo; k: in clau; changes: in out boolean) is
       
      begin
         if p = null then raise no_existe; end if;
         if k < p.k then
            borrar(p.iz, k, changes);
            if changes then bal_der(p, changes, remove_mode); end if;
         elsif k > p.k then
            borrar(p.der, k, changes);
            if changes then bal_izq(p, changes, remove_mode); end if;
         else
            borrado_real(p, changes);
         end if;
      end borrar;


      --  VARIABLES:
      changes: boolean:=false;
   begin
      borrar(a.raiz,k,changes);
   end borrar;
   
   ---------------------------------------------------------------------------------------------------                           

   procedure consultar(a: in out avltree; k: in clau; x: out element) is
      
      procedure consulta(a: in out pnodo; k: in clau; x: out element) is
      begin
         if k < a.k then                               -- SI LA CLAVE QUE BUSCAMOS ES MENOR QUE LA DE LA RAIZ                            
            consulta(a.iz,k,x);                               
         elsif k > a.k then                            -- SI ES MAYOR, VAMOS A BUSCAR AL SUBARBOL DERECHO
            consulta(a.der,k,x);
         else
            x := a.e;                                 -- SI LA HEMOS ENCONTRADO, LA DEVOLVEMOS
         end if;
      end consulta;

   begin
      consulta(a.raiz,k,x);
   end consultar;
   
   ---------------------------------------------------------------------------------------------------

   procedure actualizar(a: in out avltree; k: in clau; x: in element) is
      
      procedure actualiza(a: in out pnodo; k: in clau; x: in element) is
      begin
         if k < a.k then                               -- SI LA CLAVE QUE BUSCAMOS ES MENOR QUE LA DE LA RAIZ                            
            actualiza(a.iz,k,x);                               
         elsif k > a.k then                            -- SI ES MAYOR, VAMOS A BUSCAR AL SUBARBOL DERECHO
            actualiza(a.der,k,x);
         else
            a.e := x;                                  -- SI LA HEMOS ENCONTRADO, LA DEVOLVEMOS
         end if;
      end actualiza;

   begin
      actualiza(a.raiz,k,x);
   end actualizar;
   
   ---------------------------------------------------------------------------------------------------

   function is_valid(it: in iterador) return boolean is
   begin
      return not is_empty(it.s);
   end is_valid;
   
   ---------------------------------------------------------------------------------------------------

   procedure first(a: in avltree; it: in out iterador) is
      raiz: pnodo renames a.raiz;
      st: stack renames it.s;
      p: pnodo;
   begin
      empty(st);
      if raiz /= null then
         p := raiz;
         while p.iz /= null loop
            push(st,p);
            p := p.iz;
         end loop;
         push(st,p);
      end if;
   end first;

   ---------------------------------------------------------------------------------------------------

   procedure next(a: in avltree; it: in out iterador) is
      st: stack renames it.s;
      p: pnodo;
   begin
      p := top(st);
      pop(st);
      if p.der /= null then 
         p:= p.der;
         while p.iz /= null loop
            push(st, p);
            p := p.iz;
         end loop;
         push(st, p);
      end if;
   end next;
   
   ---------------------------------------------------------------------------------------------------
   
   procedure get(a: in avltree; it: in iterador; k: out clau; x: out element) is
      st: stack renames it.s;
      p: pnodo;
   begin
      p := top(st); k:= p.k; x:= p.e;
   end get;
   
  ---------------------------------------------------------------------------------------------------

end arbolavl;
