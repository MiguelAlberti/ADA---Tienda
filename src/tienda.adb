with ada.Text_IO;
use ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;
with estoc;


procedure Tienda is

   max: integer := 5000000;



   package mi_estoc is new estoc(max);
   use mi_estoc;
   EstocTienda : destoc; --nombre de nuestro estoc

   k: codigo;
   m : marca;
   u,code : Integer;
   n : nombre;
   nom: String (1..25);
   opcion: Integer :=0;


   procedure Anadir_Producto is
      x:Integer;
      l: natural;
   begin
      Put_Line("Introduce el numero de la marca deseada:");
      Put_Line("1)Nike 2)Adidas 3)Reebok 4)Asics 5)Fila 6)Puma 7)Quicksilver 8)Kappa 9)Converse");
      Get(x);
      m :=  marca'Val(x-1);
      Skip_Line;
      Put_Line("Introduce un nombre para el producto");
      Get_Line(nom,l);
      n := nombre(nom);
      Put_Line("Introduce las unidades del producto");
      Get(u);
      Put_Line("Introduce el código del producto");
      Get(code);
      k := codigo(code);
      poner_producto(EstocTienda,m,k,n,u);
   end Anadir_Producto;


   procedure Eliminar_Producto  is
      aux : integer;
   begin
      Put_Line("Introduce el codigo del producto que desea eliminar");
      Get(aux);
      k := codigo(aux);
      borrar_producto(EstocTienda,k);
   end Eliminar_Producto;


   procedure Mostrar_Producto_Marca  is
      x : Integer;
   begin
      Put_Line("Introduce el numero de la marca que desea ver:");
      Put_Line("1)Nike 2)Adidas 3)Reebok 4)Asics 5)Fila 6)Puma 7)Quicksilver 8)Kappa 9)Converse");
      Get(x);
      m :=  marca'Val(x-1);
      imprimir_productos_marca (EstocTienda, m);
   end Mostrar_Producto_Marca;


   procedure Mostrar_Productos is
   begin
      imprimir_estoc_total(EstocTienda);
   end Mostrar_Productos;

   procedure Menu  is
   begin
      Put_Line("Elige una opcion");
      Put_Line("Opcion 1: Poner producto");
      Put_Line("Opcion 2: Borrar un producto");
      Put_Line("Opcion 3: Mostrar los productos de una marca");
      Put_Line("Opcion 4: Mostrar todos los productos");
      Put_Line("Opcion 5: Salir ");
   end Menu;

begin

   estoc_vacio (EstocTienda); -- nos encargamos de vaciar la ED
   while opcion /= 5 loop
      Menu;
      Get(opcion);
      case opcion is
         when 1 => Anadir_Producto;
         when 2 => Eliminar_Producto;
         when 3 => Mostrar_Producto_Marca;
         when 4 => Mostrar_Productos;
         when 5 => opcion:=5;
         when others => Put_Line("Introduzca una opcion correcta");
      end case;
   end loop;

end Tienda;
