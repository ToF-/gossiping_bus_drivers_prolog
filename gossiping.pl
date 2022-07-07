:- module(gossiping,[main/0,stopAt/5,gossips/6,minutes/1,solution/4]).

:- use_module(library(readutil)).


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

minutes(Minutes) :- 
    findall(M,between(0,480,M),Minutes).

stopAt(MaxStops,Routes,Driver, Minute, Station) :-
    nth0(Driver,MaxStops,Stops),
    Time is Minute mod Stops,
    nth0(Driver,Routes,Route),
    nth0(Time,Route,Station).

gossips(_,_,_,Driver, -1, [Driver]).

gossips(_,_,_,_,480, Result) :-
    write(never),
    nl,
    append([],[],Result).

gossips(MaxDrivers, MaxStops, Routes, Receiver, Minute, Gossips) :-
    Minute >= 0,
    stopAt(MaxStops,Routes,Receiver, Minute, Station),
    MaxDriver is MaxDrivers - 1,
    findall(Driver, (between(0,MaxDriver,Driver),stopAt(MaxStops,Routes,Driver, Minute, Station)), Drivers),
    MinuteMinus1 is Minute - 1,
    setof(PreviousGossips, D^ ( member(D, Drivers), gossips(MaxDrivers, MaxStops, Routes, D, MinuteMinus1, PreviousGossips)), AllGossips),
    foldl(union, AllGossips, [], FoldedGossips),
    sort(FoldedGossips, Gossips).

solution(MaxDrivers,MaxStops,Routes,Result) :-
    minutes(Minutes),
    setof(M, M^(member(M,Minutes), setof(D,(gossips(MaxDrivers,MaxStops,Routes,D,M,_)),DS), length(DS,3),!),MS), min_list(MS, Result).


read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_codes(Stream, Codes),
    atom_chars(X, Codes),
    read_file(Stream,L).

get_routes(0,_,[],[]).

get_routes(N,[X|[XS|L]], MaxStops,Routes) :-
    N1 is N - 1,
    get_routes(N1, L, MaxStops1, Routes1),
    text_to_string(X,S),
    number_string(MaxStop,S),
    atom_string(XS,String),
    split_string(String," ","",List),
    maplist(number_string,Stops,List),
    append([MaxStop],MaxStops1,MaxStops),
    append([Stops],Routes1,Routes).

get_data([X|L],MaxDrivers,MaxStops,Routes) :-
    text_to_string(X,S),
    number_string(MaxDrivers,S),
    get_routes(MaxDrivers,L,MaxStops,Routes).

main :-
    current_prolog_flag(argv, [FileName| _]),
    open(FileName, read, Str),
    read_file(Str, Lines),
    get_data(Lines, MaxDrivers, MaxStops, Routes),
    solution(MaxDrivers, MaxStops, Routes, Result),
    writef("drivers:%t max stops:%t routes:%t\n",[MaxDrivers, MaxStops, Routes]),
    writef("solution:%t\n",[Result]).
