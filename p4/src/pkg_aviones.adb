package body pkg_aviones is

   task body TareaGeneraAviones is
      tarea_avion:Ptr_TareaAvion;
      ptr_avion:Ptr_T_RecordAvion;

      package pkg_DigitoAleatorio is new Ada.Numerics.Discrete_Random(T_RetardoAparicionAviones);
      generador_digito:pkg_DigitoAleatorio.Generator;
      retardo:T_RetardoAparicionAviones;

   begin
      pkg_DigitoAleatorio.Reset(generador_digito);

      for id in T_IdAvion loop
         for aerovia in T_Rango_Aerovia'First..T_Rango_Aerovia'Last-2 loop
            ptr_avion := new T_RecordAvion;
            ptr_avion.id := id;
            ptr_avion.pos := pkg_graficos.Pos_Inicio(aerovia);
            ptr_avion.velocidad.x := (if aerovia mod 2 = 1 then VELOCIDAD_VUELO else -VELOCIDAD_VUELO);
            ptr_avion.velocidad.y := 0;
            ptr_avion.color := Blue;
            ptr_avion.aerovia := aerovia;
            ptr_avion.aerovia_inicial := aerovia;
            ptr_avion.pista := SIN_PISTA;
            ptr_avion.tren_aterrizaje := False;
            tarea_avion := new T_TareaAvion(ptr_avion);

            retardo := pkg_DigitoAleatorio.Random(generador_digito);
            delay(duration(retardo));
         end loop;
      end loop;

   exception
      when event: others =>
         pkg_debug.Escribir("ERROR en TASK pkg_aviones: " & Exception_Name(Exception_Identity(event)));
         pkg_graficos.Desaparece(ptr_avion.all);
   end TareaGeneraAviones;

   task body T_TareaAvion is
      t_inicio:Time;
      t_acceso:Time;
      posicion_nueva:T_Rango_Rejilla_X;
      posicion_actual:T_Rango_Rejilla_X;
   begin
      pkg_debug.Escribir("TASK Avion: " & T_IdAvion'Image(ptr_avion.id) & " -" & T_Rango_AeroVia'Image(ptr_avion.aerovia));

      t_inicio := Clock;

      arr_aerovias(ptr_avion.aerovia).AeroviaDisponible(pkg_graficos.Posicion_ZonaEspacioAereo(ptr_avion.pos.X));

      t_acceso := Clock;
      if t_acceso - t_inicio > To_Time_Span(1.0) then
         ptr_avion.color := Yellow;
      end if;

      pkg_graficos.Aparece(ptr_avion.all);

      loop
         begin
            posicion_actual := pkg_graficos.Posicion_ZonaEspacioAereo(ptr_avion.pos.X);
            posicion_nueva := pkg_graficos.Posicion_ZonaEspacioAereo(pkg_graficos.Nueva_PosicionX(ptr_avion.pos.X, ptr_avion.velocidad.X));

            if posicion_actual /= posicion_nueva then
               arr_aerovias(ptr_avion.aerovia).reemplazar(posicion_actual, posicion_nueva);
            end if;

            pkg_graficos.Actualiza_Movimiento(ptr_avion.all);

            delay(RETARDO_MOVIMIENTO);

         exception
            when DETECTADA_POSIBLE_COLISION =>
               pkg_debug.Escribir("Avion" & T_IdAvion'Image(ptr_avion.id) & " desaparece de la aerov�a" & T_Rango_Aerovia'Image(ptr_avion.aerovia) & " por colision");
               pkg_graficos.Desaparece(ptr_avion.all);
               exit;
         end;
      end loop;
   end T_TareaAvion;

end pkg_aviones;