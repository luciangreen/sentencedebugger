:- module(repair_generator,
    [ generate_repairs/4
    ]).

generate_repairs(first_divergence(none), _ActualTrace, _ExpectedTrace, []).
generate_repairs(first_divergence(stage(StageId, Operation)), _ActualTrace, _ExpectedTrace,
    [repair(stage(StageId), wrong_value, Operation, Replacement, Reason)]) :-
    suggested_replacement(Operation, Replacement, Reason).

suggested_replacement(remove_duplicates_buggy, remove_duplicates,
    'Use duplicate-removal stage that preserves first occurrence order.').
suggested_replacement(sort_numbers_buggy, sort_numbers,
    'Use ascending deterministic sort for numeric pipeline contracts.').
suggested_replacement(tag_error, pass_through,
    'Remove corruption stage or replace with a pure identity transformation.').
suggested_replacement(Operation, Operation,
    'Review stage contract and argument ordering for this stage.').
