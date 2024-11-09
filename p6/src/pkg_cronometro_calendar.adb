package body pkg_cronometro_calendar is

   task body activacion is
      periodo:constant Duration := 1.0;
      inicio:constant Time := Clock;
      siguiente:Time;

   begin
      siguiente := Clock;

      loop
         siguiente := siguiente + periodo;
         pkg_graficos.Actualiza_Cronometro(Clock - inicio);
         delay until siguiente;
         -- delay 1.0;
      end loop;
   end activacion;

end pkg_cronometro_calendar;

-- La tecnica con 'delay' arrastra un error acumulativo, mientras que la de con 'delay until' no tiene en cuenta el retraso de las anteriores iteraciones
