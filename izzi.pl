% ***************************************************************************
% *                                                                         *
% *                                   Izzi                                  *
% *                                                                         *
% ***************************************************************************
%                                                                           *
% Developed by:                                                             *
%               Mário Pereira  - ei09010@fe.up.pt                           *
%                              &                                            *
%                      Tiago Cruzeiro - ei09044@fe.up.pt                    *
% ***************************************************************************


% ***************************************************************************
% *                              Declarations                               *                      
% ***************************************************************************

:-use_module(library(clpfd)). 
:-use_module(library(lists)).

% Compile the tiles file
:- compile('tiles.pl').


% ***************************************************************************
% *                     Tiles and Board management                          *                      
% ***************************************************************************

% Checks if a tile is valid, using the previously loaded tile database
% valid_tile(+Tile, -Result)
% valid_tile([0,0,0,0,0,0,0,0], Result).
valid_tile([Triangle1color, Triangle2color, Triangle3color, Triangle4color, Triangle5color, Triangle6color, Triangle7color, Triangle8color], Result):-
        tile(Triangle1color, Triangle2color, Triangle3color, Triangle4color, Triangle5color, Triangle6color, Triangle7color, Triangle8color),
        Result=0;
        Result=1.     

% Creates a tile and checks if it's valid. If so, returns the tile, otherwise the predicate runs again until a valid tile is generated
% create_tile(-Tile)
% create_tile(Tile).
create_tile(Tile):-
        Triangle1color in 0..1,
        Triangle2color in 0..1,
        Triangle3color in 0..1,
        Triangle4color in 0..1,
        Triangle5color in 0..1,
        Triangle6color in 0..1,
        Triangle7color in 0..1,
        Triangle8color in 0..1,
        Tile = [Triangle1color, Triangle2color, Triangle3color, Triangle4color, Triangle5color, Triangle6color, Triangle7color, Triangle8color],
        valid_tile(Tile, _IsValid);
        create_tile(Tile).
 
% Creates a board with N valid tiles. The default board has 64 different tiles, if a bigger board is generated there will be dupplicates
% load_tiles(-Board, +N, +TempBoard)
% load_tiles(Board, 64, []).
load_tiles(Board, 0, TempBoard):-Board=TempBoard.
load_tiles(Board, N, TempBoard):-
        NewN is N-1,
        create_tile(NewTile),
        append(TempBoard, [NewTile], NewBoard),
        load_tiles(Board, NewN, NewBoard).


% Prints a single tile
% print_tile(+Tile)
% print_tile([0,0,1,0,1,1,0,1]).
print_tile([Triangle1color, Triangle2color, Triangle3color, Triangle4color, Triangle5color, Triangle6color, Triangle7color, Triangle8color]):-
        write('|'), write(Triangle1color),
        write('\\'), write(Triangle2color),
        write('|'), write(Triangle3color),
        write('/'), write(Triangle4color),
        write('|'),
        nl,
        write('|'), write(Triangle5color),
        write('/'), write(Triangle6color),
        write('|'), write(Triangle7color),
        write('\\'), write(Triangle8color),
        write('|').

% ***************************************************************************
% *                              Main cicle                                 *                      
% ***************************************************************************

izzi:-
        nl
        
        
        
        .