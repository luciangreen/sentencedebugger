:- module(divergence,
    [ build_comparisons/3,
      first_divergence/2
    ]).

build_comparisons(ActualTrace, ExpectedTrace, Comparisons) :-
    maplist(compare_stage, ActualTrace, ExpectedTrace, Comparisons).

compare_stage(
    stage_trace(Id, Operation, _InA, ActualOut, ActualStatus),
    stage_trace(Id, _ExpectedOperation, _InE, ExpectedOut, _ExpectedStatus),
    comparison(stage(Id, Operation), expected(ExpectedOut), actual(ActualOut), difference(Difference), status(Status))
) :-
    stage_status(ActualStatus, ExpectedOut, ActualOut, Status),
    difference_value(ExpectedOut, ActualOut, Difference).

stage_status(exception(_), _ExpectedOut, _ActualOut, exception).
stage_status(correct, ExpectedOut, ActualOut, correct) :-
    ExpectedOut =@= ActualOut,
    !.
stage_status(correct, _ExpectedOut, _ActualOut, wrong_value).

first_divergence(Comparisons, first_divergence(stage(Id, Operation))) :-
    member(comparison(stage(Id, Operation), _, _, _, status(Status)), Comparisons),
    Status \= correct,
    !.
first_divergence(_Comparisons, first_divergence(none)).

difference_value(Expected, Actual, none) :-
    Expected =@= Actual,
    !.
difference_value(Expected, Actual, differs(Expected, Actual)).
