:- module(process_tree,
    [ build_process_nodes/3
    ]).

build_process_nodes(Stages, Comparisons, Nodes) :-
    maplist(stage_node(Comparisons), Stages, Nodes).

stage_node(Comparisons, stage(Id, Predicate), node(Id, Predicate, unknown, unknown, Expected, Actual, Status, [])) :-
    ( member(comparison(stage(Id, Predicate), expected(Expected), actual(Actual), _, status(Status)), Comparisons) ->
        true
    ; Expected = unknown,
      Actual = unknown,
      Status = unknown
    ).
