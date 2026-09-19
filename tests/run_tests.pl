:- initialization(main).

main :-
    source_file(main, ThisFile),
    file_directory_name(ThisFile, Dir),
    load_files([
        Dir/'sentence_tests.pl',
        Dir/'decomposition_tests.pl',
        Dir/'multistage_tests.pl',
        Dir/'semantic_bug_tests.pl',
        Dir/'prolog_bug_tests.pl',
        Dir/'repair_tests.pl'
    ], [if(changed)]),
    run_tests,
    halt.
