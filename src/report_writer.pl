:- module(report_writer,
    [ build_debug_report/14,
      write_debug_report_file/2,
      report_text/2
    ]).

:- use_module(process_tree).

build_debug_report(
    Specification,
    Input,
    Expected,
    Actual,
    Stages,
    _Trace,
    Comparisons,
    FirstDivergence,
    Dependencies,
    Provenance,
    Causes,
    Repairs,
    MinimalCounterexample,
    debug_report(
        specification(Specification),
        input(Input),
        expected(Expected),
        actual(Actual),
        stages(Nodes),
        comparisons(Comparisons),
        first_divergence(FirstDivergence),
        dependencies(Dependencies),
        provenance(Provenance),
        causes(Causes),
        repairs(Repairs),
        minimal_counterexample(MinimalCounterexample)
    )
) :-
    build_process_nodes(Stages, Comparisons, Nodes).

write_debug_report_file(OutputFile, Report) :-
    report_text(Report, Text),
    setup_call_cleanup(
        open(OutputFile, write, Stream, [encoding(utf8)]),
        ( write(Stream, Text),
          nl(Stream), nl(Stream),
          write(Stream, 'MACHINE_READABLE_REPORT'), nl(Stream),
          write_term(Stream, Report, [quoted(true), fullstop(true), nl(true)])
        ),
        close(Stream)
    ).

report_text(Report, Text) :-
    with_output_to(string(Text), write_report(Report)).

write_report(debug_report(
    specification(Specification),
    input(Input),
    expected(Expected),
    actual(Actual),
    stages(Stages),
    comparisons(Comparisons),
    first_divergence(FirstDivergence),
    dependencies(Dependencies),
    provenance(_Provenance),
    causes(Causes),
    repairs(Repairs),
    minimal_counterexample(Minimal)
)) :-
    writeln('COMPLEX SENTENCE DEBUG REPORT'),
    format('Specification: ~q~n', [Specification]),
    format('Input: ~q~n', [Input]),
    format('Expected: ~q~n', [Expected]),
    format('Actual: ~q~n~n', [Actual]),
    writeln('FUNCTIONAL DECOMPOSITION'),
    forall(member(node(Id, Predicate, _, _, _, _, _, _), Stages),
        format('~d. ~q~n', [Id, Predicate])),
    nl,
    writeln('RESULTS'),
    forall(member(comparison(stage(Id, Predicate), _, _, _, status(Status)), Comparisons),
        format('Stage ~d (~q): ~q~n', [Id, Predicate, Status])),
    nl,
    format('FIRST DIVERGENCE: ~q~n', [FirstDivergence]),
    format('DEPENDENCIES: ~q~n', [Dependencies]),
    format('CAUSES: ~q~n', [Causes]),
    format('SUGGESTED REPAIRS: ~q~n', [Repairs]),
    format('MINIMAL FAILING EXAMPLE: ~q~n', [Minimal]).
