--******************* PKG_TORRE_CONTROL.ADS *****************************
-- Paquete que implementa la tarea de la torre de control
--***********************************************************************

with PKG_tipos; use PKG_tipos;
with pkg_protegidos; use pkg_protegidos;

PACKAGE PKG_Torre_Control IS

   TASK Tarea_Torre_Control IS
      ENTRY Iniciar_Torre_Control;
      ENTRY Solicitar_Descenso(aerovia: in T_Rango_AeroVia; concedido: out Boolean);
   END Tarea_Torre_Control;

end PKG_Torre_Control;
