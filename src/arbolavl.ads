with dstack;
generic

   type element is private;
   type clau is private;
   with function "<" (c1,c2: in clau) return boolean;
   with function ">" (c1,c2: in clau) return boolean;

package arbolavl is

   type avltree is limited private;
   type iterador is limited private;
   type parbol is access avltree;

   ya_existe   : exception;
   no_existe   : exception;
   mal_uso     : exception;
   overflow    : exception;  

   procedure avacio(a: out avltree);
   procedure poner_1 (a: in out avltree; k: in clau; x: in element);
   procedure consultar(a: in out avltree; k: in clau; x: out element);
   procedure borrar(a: in out avltree; k: in clau);
   procedure actualizar(a: in out avltree; k: in clau; x: in element);

   procedure first(a: in avltree; it: in out iterador);
   procedure get(a: in avltree; it: in iterador; k: out clau; x: out element);
   procedure next(a: in avltree; it: in out iterador);
   function  is_valid(it: in iterador) return Boolean;

private


   type nodo;
   type pnodo is access nodo;
   
   package it_stack is new dstack(pnodo);                            --PAQUETE PILA PARA EL ITERADOR
   use it_stack;
   
   type factor_bl is new integer range -1..1;
   type nodo is record
      e       :element;
      k       :clau;
      bl      :factor_bl;
      iz,der  :pnodo;
   end record;
   type iterador is record
      s: stack;
   end record;
   type avltree is record
      raiz    :pnodo;
   end record;

end arbolavl;
