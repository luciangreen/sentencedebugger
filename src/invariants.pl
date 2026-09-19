:- module(invariants,
    [ check_invariants/4
    ]).

check_invariants(_Stage, Input, Output, Violations) :-
    findall(V, violated(Input, Output, V), Violations).

violated(Input, Output, same_length) :-
    is_list(Input),
    is_list(Output),
    length(Input, LI),
    length(Output, LO),
    LI =\= LO.
violated(_Input, Output, uninstantiated) :-
    \+ ground(Output).
