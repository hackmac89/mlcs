% Copyright 2012 by M. Ben-Ari. GNU GPL. See copyright.txt.

%  Test four-queens program for dpll
:- ensure_loaded(neg).
:- ensure_loaded(dpll).

%  Run four-queens and save the output to a file

queens4_file(Mode) :-
  tell('four-queens.txt'),
  queens4(Mode),
  told.

%  Call dpll with the clauses for the four-queens problem  

queens4(Mode) :-
  dpll(
  [
  [p11, p12, p13, p14], 
  [p21, p22, p23, p24],
  [p31, p32, p33, p34],
  [p41, p42, p43, p44],
  
  [~p11, ~p12], [~p11, ~p13], [~p11, ~p14], 
  [~p12, ~p13], [~p12, ~p14], [~p13, ~p14],
  [~p21, ~p22], [~p21, ~p23], [~p21, ~p24],
  [~p22, ~p23], [~p22, ~p24], [~p23, ~p24],
  [~p31, ~p32], [~p31, ~p33], [~p31, ~p34],
  [~p32, ~p33], [~p32, ~p34], [~p33, ~p34],
  [~p41, ~p42], [~p41, ~p43], [~p41, ~p44],
  [~p42, ~p43], [~p42, ~p44], [~p43, ~p44],
  
  [~p11, ~p21], [~p11, ~p31], [~p11, ~p41],
  [~p21, ~p31], [~p21, ~p41], [~p31, ~p41],
  [~p12, ~p22], [~p12, ~p32], [~p12, ~p42],
  [~p22, ~p32], [~p22, ~p42], [~p32, ~p42],
  [~p13, ~p23], [~p13, ~p33], [~p13, ~p43],
  [~p23, ~p33], [~p23, ~p43], [~p33, ~p43],
  [~p14, ~p24], [~p14, ~p34], [~p14, ~p44],
  [~p24, ~p34], [~p24, ~p44], [~p34, ~p44],
  
  [~p11, ~p22], [~p11, ~p33], [~p11, ~p44],
  [~p12, ~p21], [~p12, ~p23], [~p12, ~p34],  
  [~p13, ~p22], [~p13, ~p31], [~p13, ~p24],
  [~p14, ~p23], [~p14, ~p32], [~p14, ~p41],
  [~p21, ~p32], [~p21, ~p43],
  [~p22, ~p31], [~p22, ~p33], [~p22, ~p44],
  [~p23, ~p32], [~p23, ~p41], [~p23, ~p34],
  [~p24, ~p33], [~p24, ~p42],
  [~p31, ~p42],
  [~p32, ~p41], [~p32, ~p43],
  [~p33, ~p42], [~p33, ~p44],
  [~p34, ~p43]
  ], Mode, _, _).
