:- use_module('../main').

run :-
    Spec = pipeline(cascading_bug,
        [read_list, tag_error, pass_through, pass_through, sum_numbers, return],
        [1,2,3],
        6),
    debug(Spec, [], [], Report),
    writeln(Report).
