with pkg_tipos; use pkg_tipos;
with pkg_debug;
with pkg_graficos;

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
with Ada.exceptions; use Ada.exceptions;

package pkg_aviones is
   task TareaGeneraAviones;
   task type T_TareaAvion(ptr_avion:Ptr_T_RecordAvion);
   type Ptr_TareaAvion is access T_TareaAvion;
end pkg_aviones;
