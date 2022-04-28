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
    cambiarElemento(PosX, Lista, Color, NuevaLista),
    cambiarElemento(PosY,Grid, NuevaLista, NewGrid),
    FGrid = NewGrid.
    % idealmente se cambiarian todos los elementos de 1 lista por vez (usando
    % cambiar color), y luego se intercambian listas (la actual por la modificada.
    % cambiar en Grid el elemento encontrado, luego buscar los adyacentes
    % del elemento en posX posY, y alterarlos a medida que se van encontrando
    % FGrid = Grid. (no estoy seguro de que es correcto, consultar)

%!
% Predicado para encontrar una lista por su posicion (_, Y) en una
% matriz/grid, con iniciales (0, 0) hasta (n-1, n-1).
% (Pensado para ser usado con el predicado encontrar elemento).

encontrarLista([Lista|_], Y, Rta):-
	Y = 0, Rta = Lista.

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