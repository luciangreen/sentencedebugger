:- module(repair_verifier,
    [ verify_repairs/3
    ]).

:- use_module(trace_engine, [trace_stages/5]).

verify_repairs(Repairs, Options, Verified) :-
    maplist(verify_repair(Options), Repairs, Verified).

verify_repair(Options,
    repair(Stage, Cause, Existing, Replacement, Reason),
    repair(Stage, Cause, Existing, Replacement, Reason, verification(Status))) :-
    ( member(verification_context(Stages, Input, ExpectedOutput), Options) ->
        ( repair_succeeds(Stages, Input, ExpectedOutput, Stage, Existing, Replacement) ->
            Status = verified
        ; Status = failed
        )
    ; Status = unverified
    ).

repair_succeeds(Stages, Input, ExpectedOutput, stage(StageId), Existing, Replacement) :-
    integer(StageId),
    replace_stage(Stages, StageId, Existing, Replacement, RepairedStages),
    catch(
        ( trace_stages(RepairedStages, Input, actual, Trace, ActualOutput),
          maplist(stage_succeeded, Trace),
          ActualOutput =@= ExpectedOutput
        ),
        _,
        fail
    ).

replace_stage([stage(Id, Operation)|Rest], StageId, Existing, Replacement,
    [stage(Id, Replacement)|Rest]) :-
    Id =:= StageId,
    Operation == Existing,
    !.
replace_stage([Stage|Rest], StageId, Existing, Replacement, [Stage|RepairedRest]) :-
    replace_stage(Rest, StageId, Existing, Replacement, RepairedRest).

stage_succeeded(stage_trace(_, _, _, _, correct)).
