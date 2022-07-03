% to run the tests:
% swipl -g run_tests -t halt gossiping_tests.pl

:- begin_tests(gossiping_time).


:- use_module('gossiping'). 

test('albert at time 0 stops at station fleurs') :-
    stopAt(albert, 0, fleurs).
test('albert at time 5 stops at station planete') :-
    stopAt(albert, 5, planete).
test('barnabe at time 6 stops at station fleurs') :-
    stopAt(barnabe, 6, fleurs).
test('not all drivers have the same route length') :-
    stopAt(clara, 4, clocher),
    stopAt(clara, 5, melodie).
test('at minute 0, albert has albert and barnabe\'s gossips') :-
    gossips(albert,0,[albert,barnabe]).
test('at minute 0, barnabe has albert and barnabe\'s gossips') :-
    gossips(barnabe,0,[albert,barnabe]).
test('at minute 0 clara has only her gossips') :-
    gossips(clara,0,[clara]).
test('at minute 1, clara and barnabe share their gossips from minute 0') :-
    gossips(clara, 1, [albert,barnabe,clara]).

:- end_tests(gossiping_time).


