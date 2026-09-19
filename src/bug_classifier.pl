:- module(bug_classifier,
    [ classify_bugs/3
    ]).

:- use_module(dependency_graph).

classify_bugs(Comparisons, Dependencies, Bugs) :-
    ( first_incorrect_stage(Comparisons, StageId, Operation) ->
        downstream_from(StageId, Dependencies, Downstream),
        Bug1 = bug(1, dependency_bug(stage(StageId, Operation)),
            evidence([first_divergence(stage(StageId)), downstream_failures(Downstream)])),
        semantic_bugs(Comparisons, SemanticBugs),
        Bugs = [Bug1|SemanticBugs]
    ; Bugs = []
    ).

first_incorrect_stage(Comparisons, StageId, Operation) :-
    member(comparison(stage(StageId, Operation), _, _, _, status(Status)), Comparisons),
    Status \= correct,
    !.

semantic_bugs(Comparisons, Bugs) :-
    has_operation(Comparisons, sort_numbers, SortStage),
    has_operation(Comparisons, find_original_positions, PosStage),
    PosStage > SortStage,
    !,
    Bugs = [bug(2, data_loss_bug(stage(SortStage, sort_numbers)),
        evidence([ordering_bug, lost_original_positions]))].
semantic_bugs(_, []).

has_operation(Comparisons, Operation, Stage) :-
    member(comparison(stage(Stage, Operation), _, _, _, _), Comparisons).
