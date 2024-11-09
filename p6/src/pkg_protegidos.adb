package body pkg_protegidos is

   protected body OP_Aerovia is
      function nAviones return TContador is
      begin
         return n_aviones;
      end nAviones;
      
      procedure nAvionesIncr is
      begin 
         n_aviones := n_aviones+1;
      end nAvionesIncr;
      
      procedure nAvionesDecr is
      begin 
         n_aviones := n_aviones-1;
      end nAvionesDecr;
      
      function esPosicionLibre(X: in T_Rango_Rejilla_X) return Boolean is
      begin
         return not rejilla(X);
      end esPosicionLibre;
      
      procedure ocupar(X:T_Rango_Rejilla_X) is 
      begin
         rejilla(X-1) := True;
         rejilla(X) := True;
         rejilla(X+1) := True;
      end ocupar;
      
      procedure liberar(X:T_Rango_Rejilla_X) is 
      begin 
         rejilla(X-1) := False;
         rejilla(X) := False;
         rejilla(X+1) := False;
      end liberar;
      
      procedure reemplazar(X_actual:T_Rango_Rejilla_X; X_nueva:T_Rango_Rejilla_X) is
      begin
         liberar(X_actual);
         ocupar(X_nueva);
      end reemplazar;
      
      entry AeroviaDisponible(X:T_Rango_Rejilla_X) when
        n_aviones < MAX_AVIONES_AEROVIA
        and esPosicionLibre(T_Rango_Rejilla_X'First)
        and esPosicionLibre(T_Rango_Rejilla_X'First + 1)
        and esPosicionLibre(T_Rango_Rejilla_X'Last)
        and esPosicionLibre(T_Rango_Rejilla_X'Last - 1)
      is
      begin
         ocupar(X); -- X = T_Rango_Rejilla_X'First or T_Rango_Rejilla_X'Last)  
         nAvionesIncr;
      end AeroviaDisponible;

   end OP_Aerovia;
   
   protected body OP_Pista is

      procedure ocupar is
      begin
         libre := False;
      end ocupar;

      procedure liberar is
      begin
         libre := True;
      end liberar;

      entry aterrizar when
        libre
      is
      begin
         ocupar;
      end aterrizar;

   end OP_Pista;

end pkg_protegidos;
