:- begin_tests(sentence_debugger_semantic).

:- use_module('../main').

test(data_loss_bug_classified) :-
    Spec = pipeline(semantic_issue,
        [sort_numbers, find_original_positions, return],
        [3,1,3],
        [2,1,3]),
    debug(Spec, [], [], Report),
    Report = debug_report(_, _, _, _, _, _, _, _, _, causes(Causes), _, _),
    member(bug(2, data_loss_bug(_), _), Causes).

:- end_tests(sentence_debugger_semantic).
