:- module(proylcc,
	[
		flick/5
	]).

%!
%
% Flick(+Grid, +Color, +PosX, +PosY, -FGrid) <- esto es si se guarda el estado en React
%
% Caso contrario, se debe sacar, y realizar un predicado extra (assert) para guardar
% posicion inicial, y luego consultarla.
%
% FGrid es el resultado de hacer 'flick' de la grilla Grid con el color Color.
% Retorna false si Color coincide con el color de la celda superior izquierda de la grilla.

flick(Grid, Color, PosX, PosY, FGrid):-
    encontrarLista(Grid,PosY,Lista),
    encontrarElemento(Lista, PosX, Elem),
    dif(Color,Elem),
    adyacentes(Grid, Elem, PosX, PosY, [], ListadeAdyacentes),
    cambiarElemento(PosX, Lista, Color, NuevaLista),
    cambiarElemento(PosY,Grid, NuevaLista, NewGrid),
    FGrid = ListadeAdyacentes.
    % idealmente se cambiarian todos los elementos de 1 lista por vez (usando
    % cambiar color), y luego se intercambian listas (la actual por la modificada.
    % cambiar en Grid el elemento encontrado, luego buscar los adyacentes
    % del elemento en posX posY, y alterarlos a medida que se van encontrando
    % FGrid = Grid. (no estoy seguro de que es correcto, consultar)

%!
% Predicado para encontrar una lista por su posicion (_, Y) en una
% matriz/grid, con iniciales (0, 0) hasta (n-1, n-1).
% (Pensado para ser usado con el predicado encontrar elemento).

encontrarLista([Lista|_], 0, Lista).

encontrarLista([_|RESTO],Y,Rta):-
    (Y=\=0, Aux is Y-1,encontrarLista(RESTO,Aux,Rta)).

%!
% Predicado para econtrar el X-esimo elemento de una lista.
% Utiliza el predicado nth0/3.
encontrarElemento(Lista,X,Elem):-
	nth0(X,Lista,Elem).

%!
%Cambia el elemento de una lista por otro. utiliza el nth0/4,
% Utilizado para dada una lista, cambiar un color por otro y retornar la
% lista resultado. Tambien utilizado para dada una lista de listas,
% intercambiar una lista por otra y retornar la nueva lista de listas.
cambiarElemento(PosX, Lista, Color, Res) :-
  nth0(PosX, Lista, _, Aux),
  nth0(PosX, Res, Color, Aux).


compare([[X|Xy]|T],[Z|Zy]):-
    equal([X|Xy],[Z|Zy]);compare(T,[Z|Zy]).

equal([],[]).

equal([X|Xy],[Z|Zy]):-
     X is Z,equal(Xy,Zy).


%!
% Este predicado tiene como objetivo encontrar todos los adyacentes de
% una posicion dada, que cumplan con la condicion de que tengan el mismo
% color que la primer posicion encontrada. Este predicado es recursivo,
% y buscara todas las posiciones que cumplan con la condicion de
% adyacencia (ver predicado "adyacentes")
%!
% Este predicado tiene como objetivo encontrar todos los adyacentes de
% una posicion dada, que cumplan con la condicion de que tengan el mismo
% color que la primer posicion encontrada. Este predicado es recursivo,
% y buscara todas las posiciones que cumplan con la condicion de
% adyacencia (ver predicado "adyacentes")
adyacentesC(Grid, Color, PosX, PosY, LARGO, ListaRes, ListaAdyacentes):-
   ((PosX<0;PosY<0;PosX>LARGO;PosY>LARGO),(append(ListaRes,[],ListaAdyacentes)));
   (encontrarLista(Grid,PosY,ListaY),
    encontrarElemento(ListaY,PosX,Elem),
    ((not(dif(Color,Elem)),not(compare(ListaRes,[PosX,PosY])), %cambiar por una version que compare listas
     (XAux1 is PosX-1,
      XAux2 is PosX+1,
      YAux1 is PosY-1,
      YAux2 is PosY+1,
      append(ListaRes,[[PosX,PosY]],LResAux),
        adyacentesC(Grid,Color,PosX,YAux1,LARGO,LResAux,ResAux1),
         ((ResAux1 = [], adyacentesC(Grid,Color, XAux1,PosY,LARGO,LResAux,ResAux2));
         (not(ResAux1 = []),adyacentesC(Grid,Color, XAux1,PosY,LARGO,ResAux1,ResAux2))),
         (   (not(ResAux2 = []), adyacentesC(Grid,Color, PosX,YAux2,LARGO,ResAux2,ResAux3));
             (not(ResAux1 = []), adyacentesC(Grid,Color, PosX,YAux2,LARGO,ResAux1,ResAux3));
             ((ResAux2 = []),(ResAux1 = []), adyacentesC(Grid,Color, PosX,YAux2,LARGO,ResAux2,ResAux3))
         ),
         ((not(ResAux3 = []), adyacentesC(Grid,Color, XAux2,PosY,LARGO,ResAux3,ListaAdyacentes));
         (not(ResAux2 = []), adyacentesC(Grid,Color, XAux2,PosY,LARGO,ResAux2,ListaAdyacentes));
         (not(ResAux1 = []), adyacentesC(Grid,Color, XAux2,PosY,LARGO,ResAux1,ListaAdyacentes));
        ((ResAux3 = []), (ResAux2 = []), (ResAux1 = [])),adyacentesC(Grid,Color,XAux2,PosY,LARGO,LResAux,ListaAdyacentes))
     ));
        append(ListaRes,[],ListaAdyacentes)
   )).
%!
%Predicado base para hallar los adyacentes de una posicion dada,
% este agrega la posicion principal a la lista de adyacentes, y procede
% a verificar en sus 4 direcciones si tienen algun adyacente.
% Una celda adyacente es aquella que es vecina (se encuentra a 1
% posicion en X o Y), y contiene el mismo color que la Celda de la cual
% se compara adyacencia.
%!
%Predicado base para hallar los adyacentes de una posicion dada,
% este agrega la posicion principal a la lista de adyacentes, y procede
% a verificar en sus 4 direcciones si tienen algun adyacente.
% Una celda adyacente es aquella que es vecina (se encuentra a 1
% posicion en X o Y), y contiene el mismo color que la Celda de la cual
% se compara adyacencia.
adyacentes(Grid, Color, PosX, PosY, ListaRes, ListaAdyacentes):-
    ListaRes = [],
    encontrarLista(Grid,PosY,ListaY),
    length(ListaY,L),
    LARGO is L-1,
    encontrarElemento(ListaY,PosX,Elem),
    not(dif(Color,Elem)),
    append(ListaRes,[[PosX,PosY]],LRes),
    (dif(PosX, 0), XAux1 is PosX-1, adyacentesC(Grid,Color, XAux1,PosY, LARGO, LRes,ResAux1)),
    (dif(PosX, LARGO), XAux2 is PosX+1,
      ((ResAux1 = [], adyacentesC(Grid,Color, XAux2,PosY,LARGO,LRes,ResAux2));
      (not(ResAux1 = []),adyacentesC(Grid,Color, XAux2,PosY,LARGO,ResAux1,ResAux2)))),
    (dif(PosY, 0),YAux1 is PosY-1,
      (not(ResAux2 = []), adyacentesC(Grid,Color, PosX,YAux1,LARGO,ResAux2,ResAux3));
      (not(ResAux1 = []), adyacentesC(Grid,Color, PosX,YAux1,LARGO,ResAux1,ResAux3));
      (adyacentesC(Grid,Color, PosX,YAux1,LARGO,LRes,ResAux3))),
    (dif(PosY, LARGO), YAux2 is PosY+1,
      (not(ResAux3 = []), adyacentesC(Grid,Color, PosX,YAux2,LARGO,ResAux3,ResAux4));
      (not(ResAux2 = []), adyacentesC(Grid,Color, PosX,YAux2,LARGO,ResAux2,ResAux4));
      (not(ResAux1 = []), adyacentesC(Grid,Color, PosX,YAux2,LARGO,ResAux1,ResAux4));
      (adyacentesC(Grid,Color, PosX,YAux1,LARGO,LRes,ResAux4))),
    ((not(ResAux4 = []), append(ResAux4, [], ListaAdyacentes));
    (not(ResAux3 = []),  append(ResAux3, [], ListaAdyacentes));
    (not(ResAux2 = []), append(ResAux2, [], ListaAdyacentes));
    (not(ResAux1 = []), append(ResAux1, [], ListaAdyacentes));
   append([],[],ListaAdyacentes)).