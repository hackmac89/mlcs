% Copyright 2012-13 by M. Ben-Ari. GNU GPL. See copyright.txt.

:- module(display,
     [display/2, display/3, display/4, display/5, display/6]).

:- use_module([auxpred,config,counters,dot,io,modes]).


%  display
%    For each option there is a separate definition of display
%    Check that the option is set before displaying
%    These predicates will not fail; at worst they do nothing


%  Two arguments

display(assignment, Assignments) :-
  check_option(assignment), !,
  write('Conflict caused by assignments:\n'),
  write_assignments(Assignments), nl.

display(backtrack, Highest) :-
  alg_mode(ncb),
  check_option(backtrack), !,
  write('Non-chronological backtracking to level: '),
  write(Highest), nl.

display(clause, Clauses) :-
  check_option(clause), !,
  write('Clauses to be checked for satisfiability:\n'),
  write_clauses(Clauses, Clauses), nl.

display(decision, Assignment) :-
  check_option(decision), !,
  write('Decision assignment: '),
  write_assignment(Assignment, no), nl.

%  Clause learned by resolution
display(learned, Learned) :-
  check_option_not_dpll(learned), !,
  write('Learned clause from resolution: '),
  write(Learned), nl.

display(partial, Assignments) :-
  check_option(partial), !,
  write('Assignments so far:\n'),
  write_assignments(Assignments), nl.

display(result, []) :-
  check_option(result), !,
  write('Unsatisfiable:\n'),
  show_counters.

display(result, Assignments) :-
  check_option(result), !,
  write('Satisfying assignments:\n'),
  write_assignments(Assignments), nl,
  show_counters.

display(skipped, Assignment) :-
  alg_mode(ncb),
  check_option(skipped), !,
  write('Skip decision assignment: '),
  write_assignment(Assignment, no), nl.

display(variable, Variables) :-
  check_option(variable), !,
  write('Variables: '),
  write(Variables), nl.

display(_, _).


%  Three arguments

display(conflict, Conflict, Clauses) :-
  check_option(conflict), !,
  write('Conflict clause: '),
  write_clause(Conflict, Clauses), nl.

display(dot_inc, Graph, Clauses) :-
  check_option_not_dpll(dot_inc), !,
  display_dot(Graph, Clauses, no, no, []).

display(graph, Graph, Clauses) :-
  check_option_not_dpll(graph), !,
  display_graph(Graph, Clauses).

display(incremental, Graph, Clauses) :-
  check_option_not_dpll(incremental), !,
  display_graph(Graph, Clauses).

display(tree, Assignments, Conflict) :-
  check_option(tree), !,
  write_tree(Assignments, Conflict).

display(tree_inc, Assignments, Conflict) :-
  check_option(tree_inc), !,
  write_tree(Assignments, Conflict).

display(_, _, _).


%  Four arguments

%  Empty clause is a flag to prevent duplicate display from find_unit
display(evaluate, [], _, _) :- !.
display(evaluate, Clause, Reason, Literal) :-
  check_option(evaluate), !,
  write('Evaluate: '),
  write(Clause),
  write(Reason),
  display_deleted_literal(Literal).

display(resolvent, Clause1, Clause2, Resolvent) :-
  check_option_not_dpll(resolvent), !,
  write('Resolvent: of '),
  write(Clause1),
  write(' and antecedent '),
  write(Clause2),
  write(' is '),
  write(Resolvent), nl.

%  Display uip only if resolvent is also chosen
display(uip, no, Literals, Level) :-
  check_option_not_dpll(uip),
  check_option(resolvent), !,
  write('Not a UIP: two literals '),
  write(Literals),
  write(' are assigned at level: '),
  write(Level), nl.

display(uip, yes, [Literal], Level) :-
  check_option_not_dpll(uip),
  check_option(resolvent), !,
  write('UIP: one literal '),
  write(Literal),
  write(' is assigned at level: '),
  write(Level), nl.

display(unit, Assignment, Unit, Clauses) :-
  check_option(unit), !,
  write('Propagate unit: '),
  to_literal(Assignment, Literal),
  write_literal(Literal),
  write(' ('),
  write_assignment(Assignment, no),
  write(') derived from: '),
  write_clause(Unit, Clauses), nl.

display(_, _, _, _).


%  Five arguments

display(dominator, Path_List, Dominator, No_Dominator, Learned) :-
  check_option_not_dpll(dominator), !,
  write('Paths from the decision node at this level to kappa:\n'),
  write_paths(Path_List),
  write('A dominator is: '),
  write_assignment(Dominator, no), nl, 
  write('Paths from decision nodes at lower levels to kappa:\n'),
  write_paths(No_Dominator),
  write('Learned clause from dominator: '),
  write(Learned), nl.

display(_, _, _, _, _).

%  Six arguments

display(dot, Graph, Clauses, Level, Dominator, Learned) :-
  check_option_not_dpll(dot), !,
  display_dot(Graph, Clauses, Level, Dominator, Learned).

display(_, _, _, _, _, _).


% display_deleted_literal/1
%   For evaluate option, display the deleted literal, if any

display_deleted_literal(none) :- nl, !.
display_deleted_literal(Literal) :-
  write(Literal),
  write(' deleted\n').


%  check_option_not_dpll/1
%    Check option and also that the mode is not dpll

check_option_not_dpll(Option) :-
  not_dpll_mode,
  check_option(Option).


% display_dot/5
%   Common processing for display dot and dot_inc
%     Graph - the graph database
%     Clauses - the set of clauses (used when label option set)
%     Level - for dominator, emphasis the decision at this Level
%     Dominator - the dominator to emphasize
%     Learned - the learned clause for displaying cut

display_dot(Graph, Clauses, Level, Dominator, Learned) :-
  check_option(label), !,
  display_dot1(Graph, Clauses, Level, Dominator, Learned).
display_dot(Graph, _, Level, Dominator, Learned) :-
  display_dot1(Graph, [], Level, Dominator, Learned).

display_dot1(Graph, Clauses, Level, Dominator, Learned) :-
  get_file_counter(ig, N),
  write('Writing dot graph: '),
  write(N), nl,
  write_dot(Graph, Clauses, Level, Dominator, Learned).


% display_graph/2
%   Common processing for display graph and incremental
%   When label option is set, pass the list of clauses to write_graph

display_graph(Graph, Clauses) :-
  check_option(label), !,
  write('Implication graph:\n'),
  write_graph(Graph, Clauses), nl.

display_graph(Graph, _) :-
  write('Implication graph:\n'),
  write_graph(Graph, []), nl.
