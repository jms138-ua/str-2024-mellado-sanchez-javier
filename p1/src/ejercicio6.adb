with Ada.Numerics.Discrete_Random;  -- paquete genérico predefinido
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO; use Ada.Text_IO;

procedure ejercicio6 is
   subtype T_Digito is Integer range 0..9;
   -- crear instancia del paquete genérico predefinido, asignando el parámetro genérico
   package Pkg_DigitoAleatorio is new Ada.Numerics.Discrete_Random(T_Digito);
   generador_digito:pkg_DigitoAleatorio.Generator;  -- declarar generador de valores aleatorios tipo T_Digito
   digito:T_Digito;
begin
   pkg_DigitoAleatorio.Reset(generador_digito); -- Inicializa generador números aleatorios
   loop
      digito := pkg_DigitoAleatorio.Random(generador_digito); -- generar número aleatorio
      Put(digito);
      skip_line;
   end loop;
end ejercicio6;

-- El programa genera numeros aleatorios en bucle

-- En la sentencia 'Put(difito)' se utiliza el paquete 'Ada.Integer_Text_IO' prque 'T_Dijito' es un subtipo de 'Integer'
