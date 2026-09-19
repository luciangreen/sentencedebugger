:- module(counterexample,
    [ minimal_counterexample/4
    ]).

:- use_module(functional_decomposer).
:- use_module(trace_engine).

minimal_counterexample(Input, Operations, ExpectedOutput, Minimal) :-
    ( is_list(Input), Input = [_,_|_],
      candidate_counterexample(Input, Candidate),
      still_fails(Candidate, Operations, ExpectedOutput) ->
        Minimal = Candidate
    ; Minimal = Input
    ).

candidate_counterexample(Input, [X, X]) :-
    member(X, Input),
    include(=(X), Input, Matches),
    length(Matches, N),
    N >= 2,
    !.
candidate_counterexample([A,B|_], [A,B]).

still_fails(Input, Operations, ExpectedOutput) :-
    operations_to_stages(Operations, Stages),
    trace_stages(Stages, Input, actual, _ActualTrace, ActualFinal),
    ActualFinal \= ExpectedOutput.
