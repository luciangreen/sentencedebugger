:- use_module('../main').

run :-
    Spec = pipeline(multiple_independent,
        [remove_duplicates_buggy, sort_numbers_buggy, sum_numbers, return],
        [3,3,1],
        4),
    debug(Spec, [], [], Report),
    writeln(Report).
