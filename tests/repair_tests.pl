:- begin_tests(sentence_debugger_repair).

:- use_module('../main').

test(repair_is_generated_for_buggy_stage) :-
    Spec = pipeline(repair_case,
        [read_list, remove_duplicates_buggy, sum_numbers, return],
        [1,1,2],
        3),
    debug(Spec, [], [], Report),
    Report = debug_report(_, _, _, _, _, _, first_divergence(first_divergence(stage(2, remove_duplicates_buggy))), _, _, _, repairs(Repairs), _),
    Repairs \= [].

test(repair_is_verified_when_it_matches_expected_output) :-
    Spec = pipeline(repair_case,
        [read_list, remove_duplicates_buggy, sum_numbers, return],
        [1,1,2],
        3),
    debug(Spec, [], [], Report),
    Report = debug_report(_, _, _, _, _, _, _, _, _, _, repairs(Repairs), _),
    member(repair(stage(2), wrong_value, remove_duplicates_buggy, remove_duplicates, _, verification(verified)), Repairs).

test(repair_fails_when_it_does_not_match_expected_output) :-
    Spec = pipeline(repair_case,
        [read_list, remove_duplicates_buggy, sum_numbers, return],
        [1,1,2],
        4),
    debug(Spec, [], [], Report),
    Report = debug_report(_, _, _, _, _, _, _, _, _, _, repairs(Repairs), _),
    member(repair(stage(2), wrong_value, remove_duplicates_buggy, remove_duplicates, _, verification(failed)), Repairs).

:- end_tests(sentence_debugger_repair).
