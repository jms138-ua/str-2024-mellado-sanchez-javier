
package body pkg_ejercicio2 is
   procedure otroMensaje is
   begin
      Ada.Text_IO.Put_Line("Vamos a iniciarnos en el lenguaje Ada");
   end otroMensaje;

   function obtenerNotaMedia return Float is
   begin
      return notaMedia;
   end obtenerNotaMedia;
end pkg_ejercicio2;
