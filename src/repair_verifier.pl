:- module(repair_verifier,
    [ verify_repairs/3
    ]).

verify_repairs(Repairs, _Options, Verified) :-
    maplist(mark_unverified, Repairs, Verified).

mark_unverified(repair(Stage, Cause, Existing, Replacement, Reason),
    repair(Stage, Cause, Existing, Replacement, Reason, verification(unverified))).
