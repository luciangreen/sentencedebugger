:- begin_tests(sentence_debugger_predicate).

:- use_module('../main').

test(predicate_debug_to_file) :-
    OutputFile = '/home/runner/work/sentencedebugger/sentencedebugger/output/report_predicate.txt',
    debug_predicate_to_file(pipeline([read_list, remove_duplicates_buggy, sum_numbers, return]), [1,1,2], 3, OutputFile),
    exists_file(OutputFile).

:- end_tests(sentence_debugger_predicate).
