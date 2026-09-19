:- begin_tests(sentence_debugger_multistage).

:- use_module('../main').

test(buggy_sort_detected_at_stage_3) :-
    Spec = pipeline(numbers_pipeline,
        [read_list, remove_duplicates, sort_numbers_buggy, sum_numbers, return],
        [4,1,4,2],
        7),
    debug(Spec, [], [], Report),
    Report = debug_report(_, _, _, _, _, _, first_divergence(first_divergence(stage(3, sort_numbers_buggy))), _, _, _, _, _).

:- end_tests(sentence_debugger_multistage).
