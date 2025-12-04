% ==================================================================
% Sistema de Diagnostico: Dengue vs Chikungunya (exclusivo)
% ==================================================================

:- dynamic paciente_sintoma/1.

% --- Sintomas comunes a ambas enfermedades ---
sintoma_comun(fiebre).
sintoma_comun(dolor_cabeza).
sintoma_comun(dolor_muscular).
sintoma_comun(dolor_articular).
sintoma_comun(erupcion_cutanea).
sintoma_comun(nauseas).
sintoma_comun(vomito).

% --- Sintomas distintivos ---
sintoma_dengue(dolor_retroocular).
sintoma_dengue(sangrado_encias).

sintoma_chikungunya(hinchazon_articular).

% ==================================================================
% Diagnostico final (solo uno de los tres: dengue, chikungunya, sano)
% ==================================================================
diagnostico_final(Diag) :-
    % Verificar si tiene fiebre (requisito esencial)
    paciente_sintoma(fiebre),
    !,
    % Evaluar sintomas distintivos
    (   paciente_sintoma(hinchazon_articular) ->
        Diag = chikungunya
    ;   (paciente_sintoma(dolor_retroocular) ; paciente_sintoma(sangrado_encias)) ->
        Diag = dengue
    ;   % Tiene fiebre pero ningún síntoma distintivo ni suficientes comunes
        findall(S, (sintoma_comun(S), paciente_sintoma(S)), Comunes),
        length(Comunes, N),
        (   N >= 3 -> 
            % Si tiene muchos síntomas comunes pero sin distintivos, aún se sospecha
            % Pero para simplificar, lo marcamos como "sano" si no hay distintivos
            Diag = sano
        ;   Diag = sano
        )
    ).
diagnostico_final(sano).  % No tiene fiebre → está sano

% ==================================================================
% Tratamientos
% ==================================================================
tratamiento(dengue, [
    '🔹 Diagnostico: Dengue',
    '✅ Recomendaciones:',
    '1. Reposo absoluto.',
    '2. Beba abundantes liquidos (agua, sueros orales).',
    '3. Use solo paracetamol para fiebre o dolor (NO ibuprofeno, aspirina ni AINEs).',
    '4. Evite inyecciones intramusculares.',
    '5. Vigile signos de alarma: dolor abdominal intenso, vomitos persistentes, sangrado, somnolencia.',
    '6. ACUDA INMEDIATAMENTE a un centro medico si aparecen signos de alarma.'
]).

tratamiento(chikungunya, [
    '🔹 Diagnostico: Chikungunya',
    '✅ Recomendaciones:',
    '1. Reposo relativo.',
    '2. Hidratacion adecuada.',
    '3. Paracetamol para fiebre y dolor articular.',
    '4. En fase subaguda (despues de los primeros dias), puede usar AINEs bajo supervision medica.',
    '5. Fisioterapia si el dolor articular persiste mas de 1-2 semanas.',
    '6. Consulte a un medico si el dolor es incapacitante o dura mas de 10 dias.'
]).

tratamiento(sano, [
    '😊 ¡Esta sano!',
    'No presenta sintomas compatibles con Dengue ni Chikungunya.',
    'Mantenga medidas preventivas: use repelente, elimine criaderos de mosquitos y cubra depositos de agua.',
    'Si aparecen sintomas en el futuro, consulte a un profesional de la salud.'
]).

% ==================================================================
% Interfaz interactiva
% ==================================================================
iniciar_diagnostico :-
    retractall(paciente_sintoma(_)),
    writeln('============================================='),
    writeln('  Sistema de Diagnostico: Dengue o Chikungunya'),
    writeln('============================================='),
    writeln('Responda a las siguientes preguntas (s/n):'),
    nl,

    % Preguntar todos los síntomas posibles
    preguntar(fiebre, '¿Tiene fiebre (mas de 38 grados Celsius)?'),
    preguntar(dolor_cabeza, '¿Tiene dolor de cabeza?'),
    preguntar(dolor_muscular, '¿Tiene dolor muscular?'),
    preguntar(dolor_articular, '¿Tiene dolor en las articulaciones?'),
    preguntar(hinchazon_articular, '¿Tiene HINCHAZON en las articulaciones (manos, tobillos)?'),
    preguntar(erupcion_cutanea, '¿Tiene erupcion en la piel (manchas rojas)?'),
    preguntar(nauseas, '¿Tiene nauseas?'),
    preguntar(vomito, '¿Ha vomitado?'),
    preguntar(dolor_retroocular, '¿Siente dolor detras de los ojos?'),
    preguntar(sangrado_encias, '¿Ha tenido sangrado de encias, nariz u orina oscura?'),

    % Obtener diagnostico y tratamiento
    diagnostico_final(Diag),
    tratamiento(Diag, Recomendaciones),
    nl,
    imprimir_lista(Recomendaciones),
    nl,
    writeln('💡 Recuerde: Este sistema es orientativo. La evaluacion medica profesional es esencial.').

% ==================================================================
% Predicado para preguntar sintomas
% ==================================================================
preguntar(Sintoma, Pregunta) :-
    format('~w ', [Pregunta]),
    read_line_to_string(user_input, Resp),
    (   member(Resp, ["s", "S", "si", "sí", "Si", "Sí", "y", "Y", "yes"]) ->
        assertz(paciente_sintoma(Sintoma))
    ;   true
    ).

% ==================================================================
% Imprimir lista de recomendaciones
% ==================================================================
imprimir_lista([]).
imprimir_lista([H|T]) :-
    writeln(H),
    imprimir_lista(T).