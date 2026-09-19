:- use_module('../main').

run :-
    Spec = pipeline(simple_bug,
        [read_list, remove_duplicates_buggy, sort_numbers, sum_numbers, return],
        [3,3,1,2],
        6),
    debug(Spec, [], [], Report),
    writeln(Report).
