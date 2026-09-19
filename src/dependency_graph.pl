:- module(dependency_graph,
    [ stage_dependencies/2,
      downstream_from/3
    ]).

stage_dependencies(Stages, Dependencies) :-
    findall(depends(stage(Curr), stage(Prev)), sequential_dependency(Stages, Prev, Curr), Dependencies).

sequential_dependency(Stages, Prev, Curr) :-
    member(stage(Curr, _), Stages),
    Prev is Curr - 1,
    member(stage(Prev, _), Stages).

downstream_from(Stage, Dependencies, Downstream) :-
    findall(Next, reachable(Stage, Dependencies, Next), Raw),
    sort(Raw, Downstream).

reachable(Stage, Dependencies, Next) :-
    member(depends(stage(Next), stage(Stage)), Dependencies).
reachable(Stage, Dependencies, Next) :-
    member(depends(stage(Mid), stage(Stage)), Dependencies),
    reachable(Mid, Dependencies, Next).
