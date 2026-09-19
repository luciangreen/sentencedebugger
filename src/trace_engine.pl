:- module(trace_engine,
    [ trace_stages/5
    ]).

:- use_module(library(lists)).

trace_stages(Stages, Input, Mode, Trace, FinalOutput) :-
    trace_stages_(Stages, Input, Mode, Trace, FinalOutput).

trace_stages_([], Input, _, [], Input).
trace_stages_([stage(Id, Operation)|Rest], Input, Mode, [stage_trace(Id, Operation, Input, Output, Status)|TraceRest], Final) :-
    run_stage(Mode, Operation, Input, Output, Status),
    trace_stages_(Rest, Output, Mode, TraceRest, Final).

run_stage(Mode, Operation0, Input, Output, Status) :-
    operation_name(Operation0, Operation),
    catch(
        ( execute_operation(Mode, Operation, Input, Output0),
          Output = Output0,
          Status = correct
        ),
        Error,
        ( Output = error(Error),
          Status = exception(Error)
        )
    ).

operation_name(unknown(_), unknown).
operation_name(Operation, Name) :-
    ( atom(Operation) -> Name = Operation
    ; compound(Operation) -> functor(Operation, Name, _)
    ; Name = Operation
    ).

execute_operation(_, read_list, Input, Input).
execute_operation(_, remove_duplicates, Input, Unique) :-
    unique_preserve_order(Input, Unique).
execute_operation(reference, remove_duplicates_buggy, Input, Unique) :-
    unique_preserve_order(Input, Unique).
execute_operation(actual, remove_duplicates_buggy, Input, Input).
execute_operation(reference, sort_numbers_buggy, Input, Sorted) :-
    msort(Input, Sorted).
execute_operation(actual, sort_numbers_buggy, Input, Sorted) :-
    msort(Input, Asc),
    reverse(Asc, Sorted).
execute_operation(_, sort_numbers, Input, Sorted) :-
    msort(Input, Sorted).
execute_operation(_, sum_numbers, Input, Sum) :-
    must_be(list, Input),
    sum_list(Input, Sum).
execute_operation(_, return, Input, Input).
execute_operation(_, split_sentence, Input, Words) :-
    to_text(Input, Text),
    split_string(Text, " ", " \t\n\r.,!?;:", Raw),
    exclude(=(""), Raw, Words).
execute_operation(_, lowercase_words, Input, Output) :-
    maplist(word_to_lower, Input, Output).
execute_operation(_, remove_punctuation, Input, Output) :-
    maplist(strip_punctuation, Input, Output0),
    exclude(=(""), Output0, Output).
execute_operation(_, sort_words, Input, Sorted) :-
    msort(Input, Sorted).
execute_operation(reference, tag_error, Input, Input).
execute_operation(actual, tag_error, Input, Output) :-
    corrupt_value(Input, Output).
execute_operation(_, pass_through, Input, Input).
execute_operation(_, find_original_positions, Input, Positions) :-
    findall(Pos, nth1(Pos, Input, _), Positions).
execute_operation(_, unknown, Input, Input).
execute_operation(_, _, Input, Input).

corrupt_value([_|Tail], [corrupt|Tail]) :- !.
corrupt_value(Input, corrupt(Input)).

unique_preserve_order(Input, Unique) :-
    unique_preserve_order(Input, [], Rev),
    reverse(Rev, Unique).

unique_preserve_order([], Acc, Acc).
unique_preserve_order([H|T], Seen, Out) :-
    ( memberchk(H, Seen) ->
        unique_preserve_order(T, Seen, Out)
    ; unique_preserve_order(T, [H|Seen], Out)
    ).

word_to_lower(Word, Lower) :-
    to_text(Word, Text),
    string_lower(Text, Lower).

strip_punctuation(Word, Clean) :-
    to_text(Word, Text),
    string_chars(Text, Chars),
    include(is_word_char, Chars, Keep),
    string_chars(Clean, Keep).

is_word_char(Char) :-
    char_type(Char, alnum) ; Char = '_'.

to_text(Value, Text) :-
    ( string(Value) -> Text = Value
    ; atom(Value) -> atom_string(Value, Text)
    ; number(Value) -> number_string(Value, Text)
    ; term_string(Value, Text)
    ).
