with arbolavl;
generic

   max: integer;

package estoc is

   type destoc is limited private;
   
   type codigo is new Integer range 0..max;

   type marca is (Nike,Adidas,Reebok,Asics,Fila,Puma,Quicksilver,Kappa,Converse);
   
   type nombre is new string(1..25);

   --faltan excepciones
   no_quedan: exception;
   
   procedure estoc_vacio (c:out destoc);
   procedure poner_producto(c:in out destoc; m:in marca; k:in codigo;n:in nombre; unitats: in integer);
   procedure borrar_producto(c:in out destoc ; k:in codigo);
   procedure imprimir_productos_marca (c:in destoc; m: in marca);
   procedure imprimir_estoc_total(c:in destoc);

private
   
   type producto;
   type pproducto is access producto;
   
   type producto is record
      m        : marca;
      k        : codigo;
      n        : nombre;
      unidades : integer;
      next,prev  : pproducto;
   end record;
   
   function "<" (c1,c2: in codigo) return boolean;
   function ">" (c1,c2: in codigo) return boolean;
   
   package miarbol is new arbolavl(pproducto,codigo,"<",">");
   use miarbol;

   type array_marca is array (marca'First..marca'Last) of pproducto;

   type destoc is record
      arraymarcas   : array_marca;
      arbol         : avltree;
   end record;

end estoc;
