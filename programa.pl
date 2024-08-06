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

% PUNTO 4) posibilidades de                 % NO LO ENTENDI!!

posibilidadesDeAtencion(Dia, Personas) :-
    quienAtiendeV2(Persona, Dia, _), % la Persona Tiene que Atender ese dia
    findall(Persona, distinct(Persona, quienAtiende(Persona, Dia, _)), PersonasPosibles),
    combinar(PersonasPosibles, Personas).  
    
combinar([], []).
combinar([Persona|PersonasPosibles], [Persona|Personas]) :-
    combinar(PersonasPosibles, Personas).

combinar([_|PersonasPosibles], Personas) :-
    combinar(PersonasPosibles, Personas).


% PUNTO 5)

% golosinas, en cuyo caso registramos el valor en plata
% cigarrillos, de los cuales registramos todas las marcas de cigarrillos que se vendieron (ej: Marlboro y Particulares)
% bebidas, en cuyo caso registramos si son alcohólicas y la cantidad

% golosinas(ValorEnPlata)
% cigarrillos(ListaDeMarcas)
% bebidas(Alcoholicas/NO, Cantidad)

% Queremos agregar las siguientes cláusulas:
% - dodain hizo las siguientes ventas el lunes 10 de agosto: golosinas por $ 1200, cigarrillos Jockey, golosinas por $ 50
% - dodain hizo las siguientes ventas el miércoles 12 de agosto: 8 bebidas alcohólicas, 1 bebida no-alcohólica, golosinas por $ 10

% - martu hizo las siguientes ventas el miercoles 12 de agosto: golosinas por $ 1000, cigarrillos Chesterfield, Colorado y Parisiennes.

% - lucas hizo las siguientes ventas el martes 11 de agosto: golosinas por $ 600.
% - lucas hizo las siguientes ventas el martes 18 de agosto: 2 bebidas no-alcohólicas y cigarrillos Derby.

%ventas(Persona, Dia, ProductosVendidos).
ventas(dodain, dia(lunes, 10, agosto), [golosinas(1200), cigarrillos(jockey), golosinas(50)]).
ventas(dodain, dia(miercoles, 12, agosto), [bebidas(alcoholicas, 8), bebidas(noAlcoholicas, 1), golosinas(10)]).
ventas(martu, dia(miercoles, 12, agosto), [golosinas(1000), cigarrillos([chesterfield, colorado, parisiennes])]).
ventas(lucas, dia(martes, 11, agosto), [golosinas(600)]).
ventas(lucas, dia(martes, 18, agosto), [bebidas(noAlcoholicas, 2), cigarrillos(derby)]).

% Queremos saber si una persona vendedora es suertuda, esto ocurre si para todos los días en los que vendió, la primera venta que hizo fue importante. 
% Una venta es importante:
% - en el caso de las golosinas, si supera los $ 100.
% - en el caso de los cigarrillos, si tiene más de dos marcas.
% - en el caso de las bebidas, si son alcohólicas o son más de 5.

esSuertuda(Persona) :-
    ventas(Persona, _, _),      % la persona tiene ventas!! (tengo que ligar antes de que entre al forall)
    forall(ventas(Persona, _, [Venta|_]), ventaImportante(Venta)).  
    % Para Todos los Dias, la primera venta, es importante!
    
ventaImportante(golosinas(Valor)) :- Valor > 100.
ventaImportante(cigarrillos(ListaDeMarcas)) :- length(ListaDeMarcas, Cantidad), Cantidad > 2.
ventaImportante(bebidas(alcoholicas, _)).
ventaImportante(bebidas(_, Cantidad)) :- Cantidad > 5.
 










