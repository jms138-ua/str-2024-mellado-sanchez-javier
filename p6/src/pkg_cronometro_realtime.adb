package body pkg_cronometro_realtime is

   task body activacion is
      periodo:constant Time_Span := To_Time_Span(1.0);
      inicio:constant Time := Clock;
      siguiente:Time;

   begin
      siguiente := Clock;

      loop
         siguiente := siguiente + periodo;
         pkg_graficos.Actualiza_Cronometro(To_Duration(Clock - inicio));
         delay until siguiente;
         -- delay 1.0;
      end loop;
   end activacion;

end pkg_cronometro_realtime;

-- Ada.Real_Time tiene una mayor precision, ideal para sistemas en tiempo real
-- La tecnica con 'delay' arrastra un error acumulativo, mientras que la de con 'delay until' no tiene en cuenta el retraso de las anteriores iteraciones
