:- module(gossiping,[stopAt/3,gossips/3,minutes/1,solution/1]).

:- use_module(library(readutil)).

minutes(Minutes) :- 
    findall(M,between(0,479,M),Minutes).

/*
 3 1 2 3
 3 2 3 1
 4 2 3 4 5
*/
stops(0, 4).
stops(1, 4).
stops(3, 5).

stop(0, 0, 3).
stop(0, 1, 1).
stop(0, 2, 2).
stop(0, 3, 3).

stop(1, 0, 3).
stop(1, 1, 2).
stop(1, 2, 3).
stop(1, 3, 1).

stop(3, 0, 4).
stop(3, 1, 2).
stop(3, 2, 3).
stop(3, 3, 4).
stop(3, 4, 5).

stopAt(Driver, Minute, Station) :-
    stops(Driver, Stops),
    Time is Minute mod Stops,
    stop(Driver, Time, Station). 

gossips(Driver, -1, [Driver]).

gossips(Receiver, Minute, Gossips) :-
    Minute >= 0,
    stopAt(Receiver, Minute, Station),
    findall(Driver, stopAt(Driver, Minute, Station), Drivers),
    MinuteMinus1 is Minute - 1,
    setof(PreviousGossips, D^ ( member(D, Drivers), gossips(D, MinuteMinus1, PreviousGossips)), AllGossips),
    foldl(union, AllGossips, [], FoldedGossips),
    sort(FoldedGossips, Gossips).

solution(Result) :-
    minutes(Minutes),
    setof(M, M^(member(M,Minutes), setof(D,(gossips(D,M,_)),DS), length(DS,3),!),MS), min_list(MS, Result).


:- initialization(main, main).

main(_) :-
    readln([MaxDrivers]),
    write(MaxDrivers),
    nl.
