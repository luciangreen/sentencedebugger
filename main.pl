:- module(main,
    [ debug_sentence/4,
      debug_sentence_to_file/4,
      debug_predicate_to_file/4,
      debug/4
    ]).

:- use_module(src/sentence_parser).
:- use_module(src/functional_decomposer).
:- use_module(src/trace_engine).
:- use_module(src/dependency_graph).
:- use_module(src/provenance).
:- use_module(src/divergence).
:- use_module(src/bug_classifier).
:- use_module(src/counterexample).
:- use_module(src/repair_generator).
:- use_module(src/repair_verifier).
:- use_module(src/report_writer).


debug_sentence(Sentence, Input, ExpectedOutput, Report) :-
    sentence_to_operations(Sentence, Operations),
    debug_pipeline(Sentence, Operations, Input, ExpectedOutput, [], Report).


debug_sentence_to_file(Sentence, Input, ExpectedOutput, OutputFile) :-
    debug_sentence(Sentence, Input, ExpectedOutput, Report),
    write_debug_report_file(OutputFile, Report).


debug_predicate_to_file(PredicateCall, Input, ExpectedOutput, OutputFile) :-
    ( PredicateCall = pipeline(Operations) ->
        true
    ; PredicateCall =.. [_|Operations]
    ),
    debug_pipeline(PredicateCall, Operations, Input, ExpectedOutput, [], Report),
    write_debug_report_file(OutputFile, Report).


debug(Specification, _Tests, Options, Report) :-
    ( Specification = sentence(Sentence, Input, ExpectedOutput) ->
        sentence_to_operations(Sentence, Operations),
        Label = Sentence
    ; Specification = pipeline(Label, Operations, Input, ExpectedOutput) ->
        true
    ; Specification = predicate(Label, Operations, Input, ExpectedOutput) ->
        true
    ),
    debug_pipeline(Label, Operations, Input, ExpectedOutput, Options, Report).


debug_pipeline(Label, Operations, Input, ExpectedOutput, Options, Report) :-
    operations_to_stages(Operations, Stages),
    trace_stages(Stages, Input, actual, ActualTrace, ActualFinal),
    trace_stages(Stages, Input, reference, ExpectedTrace, _),
    build_comparisons(ActualTrace, ExpectedTrace, Comparisons),
    first_divergence(Comparisons, FirstDivergence),
    stage_dependencies(Stages, Dependencies),
    value_provenance(ActualTrace, Provenance),
    classify_bugs(Comparisons, Dependencies, BugClasses),
    generate_repairs(FirstDivergence, ActualTrace, ExpectedTrace, Repairs0),
    verify_repairs(Repairs0, Options, Repairs),
    minimal_counterexample(Input, Operations, ExpectedOutput, MinimalCounterexample),
    build_debug_report(
        Label,
        Input,
        ExpectedOutput,
        ActualFinal,
        Stages,
        ActualTrace,
        Comparisons,
        FirstDivergence,
        Dependencies,
        Provenance,
        BugClasses,
        Repairs,
        MinimalCounterexample,
        Report
    ).
