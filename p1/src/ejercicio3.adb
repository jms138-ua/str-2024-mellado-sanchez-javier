with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;

with pkg_ejercicio2;
use pkg_ejercicio2;

procedure ejercicio3 is
   diaClase:pkg_ejercicio2.TdiasSemana;
begin
   Ada.Text_IO.Put("Numero de alumnos: ");
   Ada.Integer_Text_IO.Put(pkg_ejercicio2.numAlumnos, Width=>0);
   Ada.Text_IO.New_Line;

   Ada.Text_IO.Put("Nota media: ");
   Ada.Float_Text_IO.Put(pkg_ejercicio2.obtenerNotaMedia, Fore=>1, Aft=>1, Exp=>0);
   Ada.Text_IO.New_Line;

   for dia in pkg_ejercicio2.TdiasSemana loop
      pkg_ejercicio2.pkg_diasSemana.Put(dia);
      Ada.Text_IO.New_Line;
   end loop;

   Ada.Text_IO.Put("Introduce un dia de la semana: ");
   pkg_ejercicio2.pkg_diasSemana.Get(diaClase);
   if diaClase = pkg_ejercicio2.Lunes then
      Ada.Text_IO.Put_Line("El " & diaClase'Image & " hay clases de STR.");
   else
      Ada.Text_IO.Put_Line("El " & diaClase'Image & " no hay clases de STR.");
   end if;

end ejercicio3;

-- La funcion getter 'obtenerNotaMedia' permite acceder a la variable privada 'notaMedia'

-- La variable de un bucle for se declara implicitamente

-- Si se introduce otro valor del tipo enumerado, saltara la excepcion 'ADA.IO_EXCEPTIONS.DATA_ERROR'
