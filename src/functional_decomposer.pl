:- module(functional_decomposer,
    [ operations_to_stages/2,
      decomposition_for_operation/2
    ]).

operations_to_stages(Operations, Stages) :-
    findall(stage(I, Operation), nth1(I, Operations, Operation), Stages).

decomposition_for_operation(solve(Input, Output),
    [ validate(Input, Valid),
      transform(Valid, Intermediate),
      optimise(Intermediate, Optimised),
      format_output(Optimised, Output)
    ]).
decomposition_for_operation(transform(Input, Output),
    [ identify_structure(Input, Structure),
      apply_rules(Structure, Changed),
      rebuild(Changed, Output)
    ]).
