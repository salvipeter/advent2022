:- use_module(library(clpfd)).

solve(M, N) :-
    ( monkey(M, A + B) -> solve(A, A1), solve(B, B1), N is A1 + B1
    ; monkey(M, A - B) -> solve(A, A1), solve(B, B1), N is A1 - B1
    ; monkey(M, A * B) -> solve(A, A1), solve(B, B1), N is A1 * B1
    ; monkey(M, A / B) -> solve(A, A1), solve(B, B1), N is A1 // B1
    ; monkey(M, N)
    ).

solve(humn, N, N) :- !.
solve(M, N, X) :-
    ( monkey(M, A + B) -> solve(A, A1, X), solve(B, B1, X), N #= A1 + B1
    ; monkey(M, A - B) -> solve(A, A1, X), solve(B, B1, X), N #= A1 - B1
    ; monkey(M, A * B) -> solve(A, A1, X), solve(B, B1, X), N #= A1 * B1
    ; monkey(M, A / B) -> solve(A, A1, X), solve(B, B1, X), N #= A1 // B1, A1 mod B1 #= 0
    ; monkey(M, N)
    ).

adv21(X) :- solve(root, X).

adv21b(X) :-
    monkey(root, AB),
    arg(1, AB, A), arg(2, AB, B),
    solve(A, N, X), solve(B, N, X).

main :- adv21(X), adv21b(Y), print((X, Y)), nl.
