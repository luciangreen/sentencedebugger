:- module(provenance,
    [ value_provenance/2
    ]).

value_provenance(Trace, Provenance) :-
    findall(Fact, provenance_fact(Trace, Fact), Provenance).

provenance_fact(Trace, produced_by(ValueId, stage(StageId))) :-
    member(stage_trace(StageId, _, _, _, _), Trace),
    atomic_list_concat([v, StageId], ValueId).
provenance_fact(Trace, consumed_by(ValueId, stage(NextId))) :-
    member(stage_trace(StageId, _, _, _, _), Trace),
    NextId is StageId + 1,
    member(stage_trace(NextId, _, _, _, _), Trace),
    atomic_list_concat([v, StageId], ValueId).
provenance_fact(Trace, derived_from(ValueId, [PrevValueId])) :-
    member(stage_trace(StageId, _, _, _, _), Trace),
    StageId > 1,
    PrevId is StageId - 1,
    atomic_list_concat([v, StageId], ValueId),
    atomic_list_concat([v, PrevId], PrevValueId).
