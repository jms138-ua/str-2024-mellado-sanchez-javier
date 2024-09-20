with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO;

with pkg_ejercicio2;

procedure ejercicio1 is
   s:String := "Comenzamos las prácticas de STR";
   mes:Natural;

begin
   Put("Hola Mundo!!! ");
   Put_Line(s);

   pkg_ejercicio2.otroMensaje;

   Put("Introduce el numero del mes (1-12): ");
   Ada.Integer_Text_IO.Get(mes);
   case mes is
      when 1 | 2 | 12 =>
         Put_Line("La estación correspondiente es Invierno");
      when 3 | 4 | 5 =>
         Put_Line("La estación correspondiente es Primavera");
      when 6 | 7 | 8 =>
         Put_Line("La estación correspondiente es Verano");
      when 9 | 10 | 11 =>
         Put_Line("La estación correspondiente es Otoño");
      when others =>
         Put_Line("Mes incorrecto");
         return;
   end case;
end ejercicio1;

-- Clausula use -> ventaja: simplicidad, inconveniente: ambiguedad

-- No pueden haber dos procedimientos porque solo se acepta una unidad de compilacion en un fichero
