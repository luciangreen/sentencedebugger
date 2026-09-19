:- begin_tests(sentence_debugger_decomposition).

:- use_module('../src/functional_decomposer').

test(operations_to_stages_creates_indexed_stages) :-
    operations_to_stages([a,b,c], Stages),
    assertion(Stages == [stage(1,a),stage(2,b),stage(3,c)]).

:- end_tests(sentence_debugger_decomposition).
