% El Kiosquito de Raquel

%atiende(Persona, Dia, Apertura, Cierre).
atiende(dodain, lunes, 9, 15).
atiende(dodain, miercoles, 9, 15).
atiende(dodain, viernes, 9, 15).

atiende(lucas, martes, 10, 20).

atiende(juanC, sabados, 18, 22).
atiende(juanC, domingos, 18, 22).

atiende(juanFdS, jueves, 10, 20).
atiende(juanFdS, viernes, 12, 20).

atiende(leoC, lunes, 14, 18).
atiende(leoC, miercoles, 14, 18).

atiende(martu, miercoles, 23, 24).

% Consideramos siempre la hora exacta, por ejemplo: 10, 14, 17. 
% Está fuera del alcance del examen contemplar horarios como 10:15 ó 17:30

% PUNTO 1)

% vale atiende los mismos días y horarios que dodain y juanC.
atiende(vale, Dia, Apertura, Cierre) :- atiende(dodain, Dia, Apertura, Cierre).
atiende(vale, Dia, Apertura, Cierre) :- atiende(juanC, Dia, Apertura, Cierre).

% nadie hace el mismo horario que leoC
hacenElMismoHorario(Persona, OtraPersona, Apertura, Cierre) :-
    atiende(Persona, _, Apertura, Cierre),
    atiende(OtraPersona, _, Apertura, Cierre),
    Persona \= OtraPersona.

% ?- hacenElMismoHorario(leoC, _, _, _).
% false.

% En realidad, por principio de universo cerrado , no agregos a la base de conocimientos
% aquello que NO tiene sentido agregar 

% maiu está pensando si hace el horario de 0 a 8 los martes y miércoles
% Como es algo que lo esta pensando, es decir, todavia NO es algo que ya esta
% concretado/definfio entonces NO lo podemos expliticar en nuestra base de conocimientos
% por principio de universo cerrado (lo desconocido se presume como falso)

atiendeElMismoDia(Persona, OtraPersona, Dia) :-
    atiende(Persona, Dia, _, _),
    atiende(OtraPersona, Dia, _, _),
    Persona \= OtraPersona.

% PUNTO 2)

quienAtiende(Persona, Dia, Hora) :-
    atiende(Persona, Dia, Apertura, Cierre),
    Apertura =< Hora,
    Hora =< Cierre.

estaDentro(Hora, Apertura, Cierre) :-
    Apertura =< Hora,
    Hora =< Cierre.

quienAtiendeV2(Persona, Dia, Hora) :-
    atiende(Persona, Dia, Apertura, Cierre),
    between(Apertura, Cierre, Hora).

% PUNTO 3) "Forever Alone"

atiendeSola(Persona, Dia, Hora) :-
    quienAtiendeV2(Persona, Dia, Hora),
    not((quienAtiendeV2(OtraPersona, Dia, Hora), OtraPersona \= Persona)).

% PUNTO 4) posibilidades de atencion

posibilidadesDeAtencion(Dia, Personas) :-
    quienAtiendeV2(Persona, Dia, _), % la Persona Tiene que Atender ese dia
    findall(Persona, distinct(Persona, quienAtiende(Persona, Dia, _)), PersonasPosibles),
    combinar(PersonasPosibles, Personas).  
    
combinar([], []).
combinar([Persona|PersonasPosibles], [Persona|Personas]) :-
    combinar(PersonasPosibles, Personas).

combinar([_|PersonasPosibles], Personas) :-
    combinar(PersonasPosibles, Personas).
