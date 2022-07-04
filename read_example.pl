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
    open('example1.txt', read, Str),
    read_file(Str,Lines),
    get_data(Lines, MaxDrivers, MaxStops, Routes),
    close(Str),
    writef("drivers:%t max stops:%t routes:%t\n",[MaxDrivers, MaxStops, Routes]).


