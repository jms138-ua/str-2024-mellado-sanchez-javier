with Ada.Text_IO;

package pkg_ejercicio2 is
   type TdiasSemana is (Lunes, Martes, Miercoles, Jueves, Viernes, Sabado, Domingo);
   package pkg_diasSemana is new Ada.Text_IO.Enumeration_Io(Enum => TdiasSemana);
   numAlumnos:Integer := 16;
   procedure otroMensaje;
   function obtenerNotaMedia return Float;
   private
       notaMedia:Float := 5.69;
end pkg_ejercicio2;
