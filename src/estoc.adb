with arbolavl;
with Ada.Text_IO; use Ada.Text_IO;

package body estoc is

   --mira si alguna marca tiene algun producto
   procedure estoc_vacio (c:out destoc ) is
   begin
      avacio(c.arbol);--vaciamos el arbol
      for m in marca loop
         c.arraymarcas(m):=null;
      end loop;
   end estoc_vacio;

   --a�ade un producto al estoc
   procedure poner_producto(c:in out destoc; m:in marca; k:in codigo; n:in nombre; unitats: in integer) is
      p   :  pproducto;
      e   :  pproducto renames c.arraymarcas(m);
   begin
      if e = null then
         e := new producto;
         e.all := (m,k,n,unitats,null,null);
         poner_1(c.arbol,k,e);
      else
         p := new producto;
         p.all := (m,k,n,unitats,e,null);
         e.prev := p;
         e := p;
         poner_1(c.arbol,k,p);
      end if;
   end poner_producto;

   --borra el elemento indicado del estoc
   procedure borrar_producto( c : in out destoc ; k:in codigo) is
      x: pproducto;
   begin
      consultar(c.arbol, k, x);
      if x.unidades = 0 then
         if x.next = null and x.prev = null then      -- Es el primer elemento de la cola de productos
            c.arraymarcas(x.m) := null;
         elsif x.next = null and x.prev /= null then  -- Es el último elemento de la lista
            x.prev.next := null;
         elsif x.next /= null and x.prev = null then  -- Es el primero de la lista
            x.next := x.next.next;
         else                                         -- Está en medio de la lista
            x.prev.next := x.next;
            x.next.prev := x.prev;
         end if;
         borrar(c.arbol,k);
      else
         x.unidades := x.unidades-1;
         actualizar(c.arbol,k,x);
      end if;
   end borrar_producto;

   --imprime todos los elementos desordenados de la marca indicada
   procedure imprimir_productos_marca ( c : in destoc; m: in marca) is
      it: pproducto;
   begin
      it := c.arraymarcas(m);
      while it /= null loop
         Put_Line("Producto: " & String(it.n) & ". Unidades: " & it.unidades'Image & "." & " Codigo: " & it.k'Image & ".");
         it := it.next;
      end loop;
   end imprimir_productos_marca;

   --imprime todos los productos de la tienda
   procedure imprimir_estoc_total(c:in destoc) is
      arbol: avltree renames c.arbol;
      it: iterador;
      k: codigo;
      x: pproducto;
   begin
      first(arbol, it);
      while is_valid(it) loop
         get(arbol, it, k, x);
         Put_Line("Marca: "& x.m'Image & ". Producto: "&String(x.n)&". Unidades "&x.unidades'Image&"." & " Codigo: " & k'Image & ".");
         next(arbol,it);
      end loop;
   end imprimir_estoc_total;


   function "<" (c1: codigo; c2: codigo) return boolean is
   begin
      return Integer(c1)<Integer(c2);
   end "<";

   function ">" (c1: codigo; c2: codigo) return boolean is
   begin
      return Integer(c1)>Integer(c2);
   end ">";

end estoc;
