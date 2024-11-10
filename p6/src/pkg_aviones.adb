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
      --t_inicio:Time;
      --t_acceso:Time;
      posicion_nueva:T_Rango_Rejilla_X;
      posicion_actual:T_Rango_Rejilla_X;
      descenso_concedido:Boolean := False;
      posicion_pista:T_Rango_Rejilla_X;

      procedure desaparece is
      begin
         posicion_actual := pkg_graficos.Posicion_ZonaEspacioAereo(ptr_avion.pos.X);
         arr_aerovias(ptr_avion.aerovia).liberar(posicion_actual);
         arr_aerovias(ptr_avion.aerovia).nAvionesDecr;
         pkg_graficos.Desaparece(ptr_avion.all);
      end desaparece;

      -- Avanza posicion
      procedure avanza is
      begin
         posicion_actual := pkg_graficos.Posicion_ZonaEspacioAereo(ptr_avion.pos.X);
         posicion_nueva := pkg_graficos.Posicion_ZonaEspacioAereo(pkg_graficos.Nueva_PosicionX(ptr_avion.pos.X, ptr_avion.velocidad.X));

         if posicion_actual /= posicion_nueva then
            arr_aerovias(ptr_avion.aerovia).reemplazar(posicion_actual, posicion_nueva);
         end if;

         pkg_graficos.Actualiza_Movimiento(ptr_avion.all);

         delay(RETARDO_MOVIMIENTO);
      end avanza;

      -- Desciende aerovia
      procedure desciende is
      begin
         posicion_actual := pkg_graficos.Posicion_ZonaEspacioAereo(ptr_avion.pos.X);
         desaparece;
         arr_aerovias(ptr_avion.aerovia+1).ocupar(posicion_actual);
         arr_aerovias(ptr_avion.aerovia+1).nAvionesIncr;
         ptr_avion.color := Blue;
         ptr_avion.aerovia := ptr_avion.aerovia+1;
         ptr_avion.velocidad.X := -ptr_avion.velocidad.X;
         ptr_avion.pos := pkg_graficos.Pos_Inicio(ptr_avion.pos.X, ptr_avion.aerovia);
         pkg_graficos.Aparece(ptr_avion.all);
      end desciende;

      -- Aterriza pista
      procedure aterriza is
      begin
         desaparece;
         ptr_avion.velocidad.X := 0;
         ptr_avion.velocidad.Y := VELOCIDAD_VUELO;
         ptr_avion.pos := pkg_graficos.Pos_Inicio(ptr_avion.pista);
         pkg_graficos.Aparece_En_Pista(ptr_avion.all);

         while not pkg_graficos.Fin_Aterrizaje(ptr_avion.pos.Y) loop
            pkg_graficos.Actualiza_Movimiento_En_Pista(ptr_avion.all);
            pkg_graficos.Reduce_Velocidad_Aterrizaje(ptr_avion.all);
            delay(RETARDO_MOVIMIENTO);
         end loop;

         arr_pistas(ptr_avion.pista).liberar;
         pkg_graficos.Desaparece_En_Pista(ptr_avion.all);
      end aterriza;

   begin
      pkg_debug.Escribir("TASK Avion: " & T_IdAvion'Image(ptr_avion.id) & " -" & T_Rango_AeroVia'Image(ptr_avion.aerovia));

      --t_inicio := Clock;

      arr_aerovias(ptr_avion.aerovia).AeroviaDisponible(pkg_graficos.Posicion_ZonaEspacioAereo(ptr_avion.pos.X));

      --t_acceso := Clock;
      --if t_acceso - t_inicio > To_Time_Span(1.0) then
      --   ptr_avion.color := Yellow;
      --end if;

      pkg_graficos.Aparece(ptr_avion.all);

      begin
         ----------------------------
         -- AVANZAR POR AEROLINEAS --

         loop
            posicion_actual := pkg_graficos.Posicion_ZonaEspacioAereo(ptr_avion.pos.X);

            if not descenso_concedido then
               select
                  Tarea_Torre_Control.Solicitar_Descenso(ptr_avion.aerovia, descenso_concedido);

                  if descenso_concedido then
                     ptr_avion.color := Yellow;
                  end if;
               then abort
                  loop
                     avanza;
                  end loop;
               end select;
            else
               -- Desciende si existe hueco en la siguiente aerovia
               if arr_aerovias(ptr_avion.aerovia+1).esPosicionLibre(posicion_actual)
                 and arr_aerovias(ptr_avion.aerovia+1).esPosicionLibre(posicion_actual-1)
                 and arr_aerovias(ptr_avion.aerovia+1).esPosicionLibre(posicion_actual+1)
               then
                  desciende;
                  descenso_concedido := False;

                  -- Termina si es la ultima aerolinea
                  if ptr_avion.aerovia = T_Rango_AeroVia'Last then
                     exit;
                  end if;
               else
                  avanza;
               end if;
            end if;
         end loop;

         ----------------------
         -- ATERRIZAR A PISTA--

         select
            Tarea_Torre_Control.Solicitar_Pista(ptr_avion.pista, ptr_avion.color);
         then abort
            loop
               avanza;
            end loop;
         end select;

         select
            Tarea_Torre_Control.Solicitar_Aterrizaje(ptr_avion.pista);
         then abort
            loop
               avanza;
            end loop;
         end select;

         ptr_avion.tren_aterrizaje := True;

         -- Espera a posicionarse sobre la pista
         posicion_pista := pkg_graficos.Posicion_ZonaEspacioAereo(pkg_graficos.Pos_Inicio(ptr_avion.pista).X);
         while posicion_actual /= posicion_pista loop
            avanza;
            posicion_actual := pkg_graficos.Posicion_ZonaEspacioAereo(ptr_avion.pos.X);
         end loop;

         aterriza;

      exception
         when DETECTADA_POSIBLE_COLISION =>
            pkg_debug.Escribir("Avion" & T_IdAvion'Image(ptr_avion.id) & " desaparece de la aerovía" & T_Rango_Aerovia'Image(ptr_avion.aerovia) & " por colision");
            pkg_graficos.Desaparece(ptr_avion.all);
         when others =>
            Put_Line("Vaya, ha habido un error :(");
      end;
   end T_TareaAvion;

end pkg_aviones;
