:- use_module('../main').

run :-
    Spec = pipeline(nested_bug,
        [pass_through, tag_error, pass_through, sum_numbers, return],
        [1,2,3],
        6),
    debug(Spec, [], [], Report),
    writeln(Report).
