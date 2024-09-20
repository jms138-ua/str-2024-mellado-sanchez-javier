with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Numerics.Discrete_Random;

package body pkg_tareas_estaticas is
   task body T_Tarea is
      subtype T_Num is Integer range a..b;
      package pkg_NumAleatorio is new Ada.Numerics.Discrete_Random(T_Num);
      use pkg_NumAleatorio;
      generador_num:Generator;
      num:T_Num;
   begin
      Reset(generador_num);
      for i in 1..20 loop
         num := Random(generador_num);
         Put(num);
         New_Line;
         delay(0.01);  -- La tarea queda suspendida 0.01 segundos
      end loop;
   end T_Tarea;
begin
   put_line("Sentencias de inicialización del paquete");
end pkg_tareas_estaticas;

-- Con 'delay' se van intercambiando las tareas. Cuando una queda suspendida otra puede ejecutarse

-- En el 'begin' podrian incluirse sentencias de extraccion de datos (ej: lectura de fichero, de base de datos, de terminal)
