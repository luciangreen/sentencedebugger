:- begin_tests(sentence_debugger_sentence).

:- use_module('../main').

test(sentence_to_pipeline_debug_no_bug) :-
    Sentence = "Read the list, remove duplicates, sort the remaining numbers, add them, and return the total.",
    Input = [3,1,3,2],
    debug_sentence(Sentence, Input, 6, Report),
    Report = debug_report(_, _, _, _, _, _, first_divergence(first_divergence(none)), _, _, _, _, _).

test(multistage_first_divergence_earliest_stage) :-
    Specification = pipeline(ten_stage,
        [pass_through, pass_through, tag_error, pass_through, pass_through,
         pass_through, pass_through, pass_through, sum_numbers, return],
        [1,2,3],
        6),
    debug(Specification, [], [], Report),
    Report = debug_report(_, _, _, _, _, _, first_divergence(first_divergence(stage(3, tag_error))), _, _, _, _, _).

test(sentence_to_file_writes_report) :-
    OutputFile = '/home/runner/work/sentencedebugger/sentencedebugger/output/report_sentence.txt',
    Sentence = "Read the list, remove duplicates, sort the remaining numbers, add them, and return the total.",
    debug_sentence_to_file(Sentence, [2,2,1], 3, OutputFile),
    exists_file(OutputFile).

:- end_tests(sentence_debugger_sentence).
