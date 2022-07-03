% to run the tests:
% swipl -g run_tests -t halt gossiping_tests.pl

:- begin_tests(gossiping_time).


:- use_module('gossiping'). 

test('driver 0 at time 0 stops at station 3') :-
    stopAt(0, 0, 3).
test('driver 0 at time 5 stops at station 1') :-
    stopAt(0, 5, 1).
test('driver 1 at time 6 stops at station 3') :-
    stopAt(1, 6, 3).
test('not all drivers have the same route length') :-
    stopAt(3, 4, 5),
    stopAt(3, 5, 4).
test('at minute 0, driver 0 has driver 0 and 1 gossips') :-
    gossips(0,0,[0,1]).
test('at minute 0, 1 has 0 and 1\'s gossips') :-
    gossips(1,0,[0,1]).
test('at minute 0 3 has only her gossips') :-
    gossips(3,0,[3]).
test('at minute 1, 3 and 1 share their gossips from minute 0') :-
    gossips(3, 1, [0,1,3]).
test('at minute 1, 0 still has not 3\'s gossip') :-
    gossips(0, 1, [0,1]).
test('minute 479 is max') :-
    minutes(M), max_list(M,N), N == 479.
test('solution is 4') :-
    solution(4).
:- end_tests(gossiping_time).


