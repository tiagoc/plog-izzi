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
        valid_tile([Triangle1color, Triangle2color, Triangle3color, Triangle4color, Triangle5color, Triangle6color, Triangle7color, Triangle8color], Result),
        Result #= 0,
        labeling([],[Triangle1color, Triangle2color, Triangle3color, Triangle4color, Triangle5color, Triangle6color, Triangle7color, Triangle8color]),
        Tile = [Triangle1color, Triangle2color, Triangle3color, Triangle4color, Triangle5color, Triangle6color, Triangle7color, Triangle8color].
 
% Creates a board with N valid tiles. The default board has 64 different tiles, if a bigger board is generated there will be dupplicates
% load_tiles(-Board, +N, +TempBoard)
% load_tiles(Board, 64, []).
load_tiles(Board, 0, TempBoard):- Board=TempBoard.
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

% Prints a line from the board
% print_board_line(+BoardLine,+ListOfSecondLines,+Mode)
% print_board_line([0,0,1,0,1,1,0,1],[],1).
print_board_line([],[],2):-nl.
print_board_line([], SecondLine, 1):-
        nl,
        print_board_line([], SecondLine, 2).
print_board_line([], [[Triangle5color, Triangle6color, Triangle7color, Triangle8color]|Tail],2):-
        write('|'), write(Triangle5color),
        write('/'), write(Triangle6color),
        write('|'), write(Triangle7color),
        write('\\'), write(Triangle8color),
        write('| '),
        print_board_line([], Tail,2).
print_board_line([[Triangle1color, Triangle2color, Triangle3color, Triangle4color, Triangle5color, Triangle6color, Triangle7color, Triangle8color]|Tail], SecondLine, 1):-
        write('|'), write(Triangle1color),
        write('\\'), write(Triangle2color),
        write('|'), write(Triangle3color),
        write('/'), write(Triangle4color),
        write('| '),
        SecondLineTile=[Triangle5color, Triangle6color, Triangle7color, Triangle8color],
        append(SecondLine, [SecondLineTile], NewSecondLine),
        print_board_line(Tail, NewSecondLine, 1).

% Processes the board for printing
% process_print_board(+Board, +LineLength, +NumberOfLines)
% process_print_board(Board, 8, 8)
process_print_board([], _LineLength, _NumberOfLines).
process_print_board(Board, LineLength, NumberOfLines):-
        NewNumberOfLines is NumberOfLines-1,
        split(Board, Line, RestOfLines, LineLength, 0, []),
        print_board_line(Line, [], 1),
        nl,
        process_print_board(RestOfLines, LineLength, NewNumberOfLines).

% Prints the board
% print_board(+Board)
% print_board(Board).
print_board(Board):-
        length(Board, BoardLength),
        LineLength is round(sqrt(BoardLength)),
        NumberOfLines=LineLength,
        nl,
        process_print_board(Board, 8, NumberOfLines). %Since the board is square LineLenght and NumberOfLines is equal
        
% Creates a custom tile with given constraints
% create_custom_tile([Triangle1color, Triangle2color, Triangle3color, Triangle4color, Triangle5color, Triangle6color, Triangle7color, Triangle8color])
% create_custom_tile([0,_,_,_,1,_,_,_]).
create_custom_tile(Tile, [Triangle1color, _, _, _, Triangle5color, _, _, _]):-
        Triangle2color in 0..1,
        Triangle3color in 0..1,
        Triangle4color in 0..1,
        Triangle6color in 0..1,
        Triangle7color in 0..1,
        Triangle8color in 0..1,
        valid_tile([Triangle1color, Triangle2color, Triangle3color, Triangle4color, Triangle5color, Triangle6color, Triangle7color, Triangle8color], Result),
        Result #= 0,
        labeling([],[Triangle2color, Triangle3color, Triangle4color, Triangle6color, Triangle7color, Triangle8color]),
        Tile = [Triangle1color, Triangle2color, Triangle3color, Triangle4color, Triangle5color, Triangle6color, Triangle7color, Triangle8color].
create_custom_tile(Tile, [_, Triangle2color, Triangle3color, _, _, _, _, _]):-
        Triangle1color in 0..1,
        Triangle4color in 0..1,
        Triangle5color in 0..1,
        Triangle6color in 0..1,
        Triangle7color in 0..1,
        Triangle8color in 0..1,
        valid_tile([Triangle1color, Triangle2color, Triangle3color, Triangle4color, Triangle5color, Triangle6color, Triangle7color, Triangle8color], Result),
        Result #= 0,
        labeling([],[Triangle1color, Triangle4color, Triangle5color, Triangle6color, Triangle7color, Triangle8color]),
        Tile = [Triangle1color, Triangle2color, Triangle3color, Triangle4color, Triangle5color, Triangle6color, Triangle7color, Triangle8color].
create_custom_tile(Tile, [_, _, _, Triangle4color, _, _, _, Triangle8color]):-
        Triangle1color in 0..1,
        Triangle2color in 0..1,
        Triangle3color in 0..1,
        Triangle5color in 0..1,
        Triangle6color in 0..1,
        Triangle7color in 0..1,
        valid_tile([Triangle1color, Triangle2color, Triangle3color, Triangle4color, Triangle5color, Triangle6color, Triangle7color, Triangle8color], Result),
        Result #= 0,
        labeling([],[Triangle1color, Triangle2color, Triangle3color, Triangle5color, Triangle6color, Triangle7color]),
        Tile = [Triangle1color, Triangle2color, Triangle3color, Triangle4color, Triangle5color, Triangle6color, Triangle7color, Triangle8color].
create_custom_tile(Tile, [_, _, _, _, _, Triangle6color, Triangle7color, _]):-
        Triangle1color in 0..1,
        Triangle2color in 0..1,
        Triangle3color in 0..1,
        Triangle4color in 0..1,
        Triangle5color in 0..1,
        Triangle8color in 0..1,
        valid_tile([Triangle1color, Triangle2color, Triangle3color, Triangle4color, Triangle5color, Triangle6color, Triangle7color, Triangle8color], Result),
        Result #= 0,
        labeling([],[Triangle1color, Triangle2color, Triangle3color, Triangle4color, Triangle5color, Triangle8color]),
        Tile = [Triangle1color, Triangle2color, Triangle3color, Triangle4color, Triangle5color, Triangle6color, Triangle7color, Triangle8color].

% generate_first_line(FirstLine,[0,0,1,0,1,1,0,1],8, []), print_board_line(FirstLine,[],1).
generate_first_line(FirstLine, _, 0, Temp):- FirstLine=Temp.
generate_first_line(FirstLine,
                    [Triangle1color, Triangle2color, Triangle3color, Triangle4color, Triangle5color, Triangle6color, Triangle7color, Triangle8color],
                    N, Temp):-
        Tile = [Triangle1color, Triangle2color, Triangle3color, Triangle4color, Triangle5color, Triangle6color, Triangle7color, Triangle8color],
        append(Temp, [Tile], NewTemp),
        Tile2Triangle1color#=Triangle4color,
        Tile2Triangle5color#=Triangle8color,
        create_custom_tile(Tile2, [Tile2Triangle1color, _, _, _, Tile2Triangle5color, _, _, _]),        
        append(Temp, [Tile2], NewTemp), 
        NewN is N-1,
        generate_first_line(FirstLine, Tile2, NewN, NewTemp).


% ***************************************************************************
% *                              Main cicle                                 *                      
% ***************************************************************************


% Generates a tile that will fit on the surrounding tiles
% next_tile(+LeftTile, +UpTile, -NextTile, +Row, +Column)
next_tile([Tile1tri1, Tile1tri2, Tile1tri3, Tile1tri4, Tile1tri5, Tile1tri6, Tile1tri7, Tile1tri8],
          [Tile2tri1, Tile2tri2, Tile2tri3, Tile2tri4, Tile2tri5, Tile2tri6, Tile2tri7, Tile2tri8],
          [Tile3tri1, Tile3tri2, Tile3tri3, Tile3tri4, Tile3tri5, Tile3tri6, Tile3tri7, Tile3tri8], Row, Column):-
        
        (
                Row =:= 1 
                        ->      Tile3tri1 #= Tile1tri4,
                                Tile3tri5 #= Tile1tri8;
                
                Column =:= 1
                        ->      Tile3tri2 #= Tile2tri6,
                                Tile3tri3 #= Tile2tri7;
                
                Tile3tri1 #= Tile1tri4,
                Tile3tri5 #= Tile1tri8,
                Tile3tri2 #= Tile2tri6,
                Tile3tri3 #= Tile2tri7
        ), 
        

        valid_tile([Tile3tri1, Tile3tri2, Tile3tri3, Tile3tri4, Tile3tri5, Tile3tri6, Tile3tri7, Tile3tri8], Result),
        
        Result#=0,
        
        alldif([[Tile1tri1, Tile1tri2, Tile1tri3, Tile1tri4, Tile1tri5, Tile1tri6, Tile1tri7, Tile1tri8],
                [Tile2tri1, Tile2tri2, Tile2tri3, Tile2tri4, Tile2tri5, Tile2tri6, Tile2tri7, Tile2tri8],
                [Tile3tri1, Tile3tri2, Tile3tri3, Tile3tri4, Tile3tri5, Tile3tri6, Tile3tri7, Tile3tri8]]),
        
        labeling([],[Tile3tri1, Tile3tri2, Tile3tri3, Tile3tri4, Tile3tri5, Tile3tri6, Tile3tri7, Tile3tri8]),
        nl.

% Solves the board
% solve_izzi(-Board, +PrevTileLeft, +PrevTileUp, +N, +Size)
% solve_izzi(Board, 62).
solve_izzi(Board, N):-        
        create_tile(Tile),
        append(Board, [Tile], NewBoard),
        solve_izzi(NewBoard, Tile, _, 2, N),
        nl.
solve_izzi(Board, _, _, 64, 0):-
        alldif(Board),
        labeling([], Board).
solve_izzi(Board, PrevTileLeft, PrevTileUp, N, Size):-        
        
        (
                N<9 ->  Column is N;
                N=:= 16 -> Column is 8;
                N=:= 24 -> Column is 8;
                N=:= 32 -> Column is 8;
                N=:= 40 -> Column is 8;
                N=:= 48 -> Column is 8;
                N=:= 56 -> Column is 8;
                N=:= 64 -> Column is 8;
                
                Column is N-(truncate(N/8))*8
        ),
        (
           Column =:= 8 -> Row is truncate(N/8);
           
           Row is truncate(N/8)+1  
        ),
        
        
        next_tile(PrevTileLeft, PrevTileUp, NextTile, Row, Column),
        append(Board, [NextTile], NewBoard),
        
        write(N),nl,write(Row),nl,write(Column),nl,write(Size),nl,
        
        NewSize is Size-1,
        NewN is N+1,
        
        (
           Column =:= 1 -> 
                        Index is N-8,
                        nthElement(NewBoard, Index, NewPrevTileUp, 0),
                        solve_izzi(NewBoard, _, NewPrevTileUp, NewN, NewSize);
           Row =:= 1 ->
                        NewPrevTileLeft = NextTile,
                        solve_izzi(NewBoard, NewPrevTileLeft, _, NewN, NewSize);
           
           Index is N-8,
           nthElement(NewBoard, Index, NewPrevTileUp, 0),   
           NewPrevTileLeft = NextTile
        ),
        
        solve_izzi(NewBoard, NewPrevTileLeft, NewPrevTileUp, NewN, NewSize),
        
        nl.




izzi:-
        
        %exactly(Tile,Board,1),
        %labeling([],FirstLine),
        %element(?X,+List,?Y),
        
        nl    
        .    

% Start Menu
% izzi(+Mode)
% izzi(0).
izzi(0):-
        write('Izzi'), nl, nl,
        write('* Menu *'),nl,
        write('1 - Load valid tiles'), nl,
        write('2 - Solve puzzle'),nl,nl,
        write('3 - Exit'), nl, nl,
        write('Your option: '),
        read(Option), 
        valid_menu_option(Option, 3, ValidOption),
        izzi(ValidOption).
start(1):-
     compile('tiles.pl'),
     write('Tiles loaded').
start(2):-
      load_tiles(Board, 64, []),
      print_board(Board),
      izzi(0).
start(3).

% Checks if the option is valid
% valid_menu_option(Option, NumberOfOptions, ValidOption)
% valid_menu_option(1, 5, ValidOption).
valid_menu_option(Option, NumberOfOptions, ValidOption):-
        Option>0, Option=<NumberOfOptions,
                ValidOption=Option;
                write('Invalid option. Please choose a number between 1 and '), write(NumberOfOptions), write(' : '),
                read(NewOption),
                valid_menu_option(NewOption, NumberOfOptions, ValidOption).

             
% ***************************************************************************
% *                   Utilities for list management                         *                      
% ***************************************************************************

% Split a list in two, where N is the middle
% split(+List, -LeftList, -RigthList, +N, +Starter, +TempList). 
split(Tail,TempList,Tail,N,N,TempList).
split([H|T], Output1, Output2, N, Counter, TempList):- 
                C is Counter+1, append(TempList,[H],NewTempList), split(T,Output1,Output2,N,C,NewTempList),!.

% Checks if all the elements of a list are different
% alldif(List).
alldif([]).
alldif([E|Es]) :-
   maplist(dif(E), Es),
   alldif(Es).

% Find the nth element of a list
% nthElement(+List, +Index, -Content, +StartingAt).
nthElement([Head|_], N, Head, N).
nthElement([_|Tail], N, Content, Counter):-
        NewCounter is Counter + 1,
        nthElement(Tail,N,Content, NewCounter),!.


% ***************************************************************************
% *                            EndOfFile                                    *                      
% ***************************************************************************