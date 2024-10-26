package body pkg_protegidos is

   protected body OP_Aerovia is
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
        and not rejilla(T_Rango_Rejilla_X'First)
        and not rejilla(T_Rango_Rejilla_X'First + 1)
        and not rejilla(T_Rango_Rejilla_X'Last)
        and not rejilla(T_Rango_Rejilla_X'Last - 1)
      is
      begin
         ocupar(X); -- X = T_Rango_Rejilla_X'First or T_Rango_Rejilla_X'Last)  
         n_aviones := n_aviones+1;
      end AeroviaDisponible;

   end OP_Aerovia;
end pkg_protegidos;
