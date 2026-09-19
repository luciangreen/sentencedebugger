:- module(predicate_analyser,
    [ analyse_predicate_call/3
    ]).

analyse_predicate_call(Call, InputBindings, result(ok, analysis(Call, InputBindings, unknown_clause, unknown_output, unknown))).
