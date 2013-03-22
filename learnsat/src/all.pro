% Copyright 2012-13 by M. Ben-Ari. GNU GPL. See copyright.txt.

% Regression testing:
%   run the examples with all display options set except
%    'evaluate' (which is trivial) and 'dot' (the graph is not needed)
%   Pigeonhole 3, Tseitin K3,3, Pebbles 3 just print the results

:- ensure_loaded([examples,pebbles,pigeon,queens,tseitin]).

all :-
  set_mode(ncb),
  set_display(all),
  clear_display([evaluate,dot,dot_inc,tree]),
  tell('all.txt'),
  print_test('Example from MLM'),
  mlm,
  print_test('Example from MZ'),
  mz,
  print_test('Example from MS'),
  ms,
  print_test('Pigeonhole 2'),
  hole2,
  print_test('Queens 4'),
  queens4,
  print_test('Tseitin example from MLCS'),
  ex,
  print_test('Tseitin example from MLCS (sat)'),
  exs,
  print_test('Tseitin K2,2'),
  k22,
  print_test('Tseitin K2,2 (sat)'),
  k22s,
  print_test('Tseitin K3,3 (sat)'),
  k33s,
  print_test('Grid pebbling 2'),
  grid2,
  clear_display(all),
  set_display(result),
  print_test('Pigeonhole 3'),
  hole3,
  print_test('Tseitin K3,3'),
  k33,
  print_test('Grid pebbling 3'),
  grid3,
  clear_display(all),
  set_display(default),
  told.

print_test(A) :-
  write('\n******************************************\n'),
  write('*'),
  atom_length(A, N),
  Half is div(40-N, 2),
  tab(Half),
  write(A),
  tab(Half),
  extra_space(N),
  write('*'),
  write('\n******************************************\n').

extra_space(N) :-
  mod(N, 2) =:= 1, !,
  write(' ').
extra_space(_).
