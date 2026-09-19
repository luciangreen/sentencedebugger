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

:- end_tests(sentence_debugger_repair).
