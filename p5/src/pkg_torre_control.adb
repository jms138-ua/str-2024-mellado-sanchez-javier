--******************* PKG_TORRE_CONTROL.ADB *****************************
-- Paquete que implementa la tarea de la torre de control
--***********************************************************************

with PKG_graficos;
with PKG_debug;
with Ada.Exceptions; use Ada.Exceptions;
with Ada.Calendar; use Ada.Calendar;

PACKAGE BODY PKG_Torre_Control IS

   -----------------------------------------------------------------------
   -- DEFINICIÓN DE LA TAREA DE LA TORRE DE CONTROL
   -----------------------------------------------------------------------
   TASK BODY Tarea_Torre_Control IS

   BEGIN
      PKG_debug.Escribir("======================INICIO TASK Torre_Control");

      ACCEPT Iniciar_Torre_Control DO
         null;
      END Iniciar_Torre_Control;

      loop
         --select
         accept Solicitar_Descenso(aerovia: in T_Rango_AeroVia; concedido: out Boolean) do
            concedido := arr_aerovias(aerovia+1).nAviones < MAX_AVIONES_AEROVIA;
         end Solicitar_Descenso;
         --end select;
         delay 2.0;
      end loop;

   exception
       when event: others =>
        PKG_debug.Escribir("ERROR en TASK Torre_Control: " & Exception_Name(Exception_Identity(event)));

   END Tarea_Torre_Control;


end PKG_Torre_Control;
