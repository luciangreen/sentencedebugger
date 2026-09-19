:- module(sentence_parser,
    [ sentence_to_operations/2,
      sentence_semantics/2
    ]).

sentence_to_operations(Sentence, Operations) :-
    normalise_sentence(Sentence, Parts),
    maplist(part_to_operation, Parts, Ops0),
    exclude(=(skip), Ops0, Operations).

sentence_semantics(Sentence, semantic_process(Operations)) :-
    sentence_to_operations(Sentence, Operations).

normalise_sentence(Sentence, Parts) :-
    to_sentence_string(Sentence, S0),
    string_lower(S0, Lower),
    normalise_connectives(Lower, Normalised),
    split_string(Normalised, ",", " \t\n\r.", RawParts),
    exclude(string_blank, RawParts, Parts).

normalise_connectives(Input, Out) :-
    foldl(replace_token, [" and then ", " then ", " and ", ";"], Input, Temp),
    Out = Temp.

replace_token(Token, In, Out) :-
    split_string(In, Token, "", Segments),
    atomic_list_concat(Segments, ',', Out).

string_blank(S) :-
    string_codes(S, Codes),
    forall(member(C, Codes), char_type(C, space)).

to_sentence_string(Sentence, String) :-
    ( string(Sentence) -> String = Sentence
    ; atom(Sentence) -> atom_string(Sentence, String)
    ; is_list(Sentence) -> atomic_list_concat(Sentence, ' ', Atom), atom_string(Atom, String)
    ).

part_to_operation(Part, Operation) :-
    ( contains(Part, "read") , contains(Part, "list") -> Operation = read_list
    ; contains(Part, "remove duplicates") -> Operation = remove_duplicates
    ; contains(Part, "remove punctuation") -> Operation = remove_punctuation
    ; contains(Part, "sort"), contains(Part, "numbers") -> Operation = sort_numbers
    ; contains(Part, "sort"), contains(Part, "words") -> Operation = sort_words
    ; contains(Part, "sum") -> Operation = sum_numbers
    ; contains(Part, "add") -> Operation = sum_numbers
    ; contains(Part, "return") -> Operation = return
    ; contains(Part, "split"), contains(Part, "sentence") -> Operation = split_sentence
    ; contains(Part, "lowercase") -> Operation = lowercase_words
    ; contains(Part, "find"), contains(Part, "original positions") -> Operation = find_original_positions
    ; contains(Part, "pass through") -> Operation = pass_through
    ; contains(Part, "introduce error") -> Operation = tag_error
    ; Operation = unknown(Part)
    ).

contains(Text, Needle) :-
    sub_string(Text, _, _, _, Needle).
