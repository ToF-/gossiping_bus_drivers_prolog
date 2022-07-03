:- module(gossiping,[stopAt/3,gossips/3]).

stops(albert, 4).
stops(barnabe, 4).
stops(clara, 5).

stop(albert, 0, fleurs).
stop(albert, 1, planete).
stop(albert, 2, micadia).
stop(albert, 3, fleurs).

stop(barnabe, 0, fleurs).
stop(barnabe, 1, micadia).
stop(barnabe, 2, fleurs).
stop(barnabe, 3, planete).

stop(clara, 0, melodie).
stop(clara, 1, micadia).
stop(clara, 2, fleurs).
stop(clara, 3, melodie).
stop(clara, 4, clocher).

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

   


