:- module(semantic_model,
    [ sentence_semantic_model/2
    ]).

:- use_module(sentence_parser, [sentence_semantics/2]).

sentence_semantic_model(Sentence, Model) :-
    sentence_semantics(Sentence, Model).
