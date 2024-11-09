with pkg_tipos; use pkg_tipos;

package pkg_protegidos is
   subtype TContador is Integer range 0..MAX_AVIONES_AEROVIA;
   protected type OP_Aerovia is
      function nAviones return TContador;
      procedure nAvionesIncr;
      procedure nAvionesDecr;
      function esPosicionLibre(X: in T_Rango_Rejilla_X) return Boolean;
      procedure ocupar(X:T_Rango_Rejilla_X);
      procedure liberar(X:T_Rango_Rejilla_X);
      procedure reemplazar(X_actual:T_Rango_Rejilla_X; X_nueva:T_Rango_Rejilla_X);
      entry AeroviaDisponible(X:T_Rango_Rejilla_X);
   private
      rejilla:T_Rejilla_Ocupacion := (others => false);
      n_aviones:TContador := 0;
   end OP_Aerovia;

   arr_aerovias:array(T_Rango_AeroVia) of OP_Aerovia;

   protected type OP_Pista is
      procedure ocupar;
      procedure liberar;
      entry aterrizar;
   private
      libre:Boolean := True;
   end OP_Pista;

   arr_pistas:array(T_PistaAterrizaje) of OP_Pista;

end pkg_protegidos;
