op1(hd, [H|_],H).
op1(tl, [_|L],L).
op1(rev,[H|T],R) :- reverse([H|T],R).
op2((+),H,S,R) :- number(H),number(S), R is H+S. 
op2((-),H,S,R) :- number(H),number(S), R is H-S. 
op2((*),H,S,R) :- number(H),number(S), R is H*S. 
op2((/),H,S,R) :- number(H),number(S), R is S/H. 
op2(append,H,I,X) :- append(H,I,X).
op2(concat,H,I,X) :- append(I,H,X).
op2(eq,H,L,R) :- H = L, !, R = true.
op2(eq,_,_,R) :- R = false.


d([        ], Ret,      Ret) :-!.
%d([drop |Cs], [_|Ss],     X) :-                d(Cs, Ss, X).
d([dup  |Cs], [H|Ss],     X) :-                d(Cs, [H,H|Ss], X).
d([rot  |Cs], [A,B,C|Ss], X) :-                d(Cs, [B,C,A|Ss], X).
d([swap |Cs], [H,S|Ss],   X) :-                d(Cs, [S,H|Ss], X).
d([over |Cs], [A,B|Ss],   X) :-                d(Cs, [B,A,B|Ss], X).
d([cons |Cs], [A,B|Ss],   X) :-                d(Cs, [[A|B]|Ss], X).
d([nop  |Cs], Ss,         X) :-                d(Cs, Ss,       X).
d([Op   |Cs], [[H|L]|Ss], X) :-      op1(Op,[H|L],R),       d(Cs, [R|Ss], X).
d([Op   |Cs], [[H|L],[I|J]|Ss],X) :- op2(Op,[H|L],[I|J],R), d(Cs, [R|Ss], X).
d([Op   |Cs], [H|Ss],     X) :-      op1(Op,H,R),   d(Cs, [R|Ss], X).
d([Op   |Cs], [H,S|Ss],   X) :-      op2(Op,H,S,R), d(Cs, [R|Ss], X).
d([[]   |Cs], Ss,         X) :-                d(Cs, [[]|Ss], X).
d([[A|L]|Cs], Ss,         X) :-                d(Cs, [[A|L]|Ss], X).
d([N    |Cs], Ss,         X) :- number(N),     d(Cs, [N|Ss], X).

run(Prg, Stack) :- d(Prg, [], Stack).
rrun(Prg, Stack) :- reverse(Prg,X),d(X, [], Stack).

is_(P,S) :- write(P),write(S),nl,run(P,S).
is_d(P,S) :- run(P,S).

test :- is_([1,2,+],        [3]),
	is_([1,2,-],        [1]),
	is_([1,2,swap],     [1,2]),
	is_([100,5,/|L],    [20|L]),
	is_([-3,dup,*|L],   [9|L]),
	is_([1,2,3,rot|L],  [2,1,3|L]),
	is_([2,3,over|L],   [2,3,2|L]),
	is_([5,5,*,4,*|L],  [100|L]),
	is_([213,213,eq],   [true]),
	is_([[]],[[]]),
	is_([[1,2]],[[1,2]]),
	is_([[1,2],[3,4]],[[3,4],[1,2]]),
	is_([[1,2],[3,4],eq],[false]),
	is_([[1,2],[1,2],eq],[true]),
	is_([[1,2],[3,4],append],[[3,4,1,2]]),
	is_([[1,2],[3,4],concat],[[1,2,3,4]]),
	is_([[1,2],[3,4],swap],[[1,2],[3,4]]),
	is_([[1,2,3],tl],[[2,3]]),
	is_([[1,2,3],hd],[1]),
	is_([[1,2],hd],[1]),
	is_([[1],hd],[1]),
	is_([[1,2,3],rev],[[3,2,1]]),
	is_([[],1,cons],[[1]]),
	is_([[],1,cons,2,cons],[[2,1]]),
	write(success),!.
