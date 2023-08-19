%node = da tenere in memoria così da memorizzare l'albero
aStar():-
    init(PosInit),
    aStar_aux([node(_,_,PosInit,[])],[],Solution,SearchCost),
    length(Solution, Depth),
    BranchingFactor is SearchCost/Depth,
    approx(BranchingFactor,2,BranchingFactorApprox),
    format("Cost of research: ~w~nRamificaction: ~w~nDepth: ~w~nSolution: ~w",
    [SearchCost,BranchingFactorApprox,Depth,Solution]).

aStar_aux([node(_,_,pos(R, C),Actions)|ResidualMoves],PerformedMoves,Solution,SearchCost):-
    final(GoalsList),
    existsFinal(R, C, GoalsList),
    reversedList(Actions, Solution),
    count(ResidualMoves,PerformedMoves,SearchCost),!.

aStar_aux([node(_,_,State,Actions)|ResidualMoves],PerformedMoves,Solution,SearchCost):-
    findall(Action,applicable(Action,State),ApplicableActions),
    length(Actions, Cost),
    generateMoves(node(Cost,[],State,Actions),ApplicableActions,[State|PerformedMoves],NewListMoves),
    final(GoalsList),
    orderMoves(NewListMoves,GoalsList,ResidualMoves,OrderedHeuristicList),
    aStar_aux(OrderedHeuristicList,[State|PerformedMoves],Solution,SearchCost).

generateMoves(_,[],_,[]):-!.

generateMoves(node(Cost,[],State,PerformedActions),[Action|OtherActions],PerformedMoves,[node(NewCost,[],NewState,[Action|PerformedActions])|ListMoves]):-
    trasform(Action,State,NewState),
    NewCost is Cost + 1,
    \+member(NewState,PerformedMoves),!,
    generateMoves(node(Cost,[],State,PerformedActions),OtherActions,PerformedMoves,ListMoves).
generateMoves(node(Cost,[],State,ActionsState),[_|OtherActions],PerformedMoves,ListMoves):-
    generateMoves(node(Cost,[],State,ActionsState),OtherActions,PerformedMoves,ListMoves).

orderMoves(NewListMoves,GoalsList,ResidualsMoves,[BestMove|OtherMoves]):-
    applyHeuristicGoals(NewListMoves,GoalsList,ListMovesHeuristic),
    append(ResidualsMoves,ListMovesHeuristic,HeuristicList),
    searchBestMove(HeuristicList,BestMove),
    delete(HeuristicList, BestMove, OtherMoves).

applyHeuristicGoals(NewListMoves,[[R, C]|[]],ListMovesHeuristic):-
    applyHeuristic(NewListMoves,R,C,ListMovesHeuristic).

applyHeuristicGoals(NewListMoves,[[R, C]|Tail],ListMovesHeuristic):-
    applyHeuristic(NewListMoves,R,C,ListMovesHeuristic1), 
    applyHeuristicGoals(NewListMoves, Tail,ListMovesHeuristic2),
    append(ListMovesHeuristic1, ListMovesHeuristic2, ListMovesHeuristic).

applyHeuristic([],_,_,[]):-!.

applyHeuristic([node(Cost,_,pos(Row,Column),PerformedActions)|ResidualsMoves],FinalRow,FinalColumn,[node(Heuristic,NextCost,pos(Row,Column),PerformedActions)|ListMovesHeuristic]):-
  calculateHeuristic(Row,Column,FinalRow,FinalColumn,NextCost),
    Heuristic is NextCost + Cost,
    applyHeuristic(ResidualsMoves,FinalRow,FinalColumn,ListMovesHeuristic).

calculateHeuristic(Row,Column,FinalRow,FinalColumn,Distance):-
    difference(Row,FinalRow,DifferenceRow),
    difference(Column,FinalColumn,DifferenceColumn),
    Distance is DifferenceRow + DifferenceColumn.

difference(A,B,Difference):- Difference is A - B, Difference >= 0,!.
difference(A,B,Difference):- Difference is B - A, Difference > 0,!.

searchBestMove([BestMove],BestMove):-!.

searchBestMove([node(BestHeuristic,NextCost,State,Actions),node(Heuristic,_,_,_)|OtherMoves],BestMove) :-
    BestHeuristic < Heuristic,
    searchBestMove([node(BestHeuristic,NextCost,State,Actions)|OtherMoves],BestMove),!.

searchBestMove([node(Heuristic,BestNextCost,State,Actions),node(Heuristic2,NextCost,_,_)|OtherMoves],BestMove) :-
    Heuristic =< Heuristic2,
    BestNextCost < NextCost,
    searchBestMove([node(Heuristic,BestNextCost,State,Actions)|OtherMoves],BestMove),!.

searchBestMove([node(Heuristic,_,_,_),node(BestHeuristic,NextCost,State,Actions)|OtherMoves],BestMove) :-
    BestHeuristic < Heuristic,
    searchBestMove([node(BestHeuristic,NextCost,State,Actions)|OtherMoves],BestMove),!.

searchBestMove([node(Heuristic2,NextCost,_,_),node(Heuristic,BestNextCost,State,Actions)|OtherMoves],BestMove) :-
    Heuristic =< Heuristic2,
    BestNextCost < NextCost,
    searchBestMove([node(Heuristic,BestNextCost,State,Actions)|OtherMoves],BestMove),!.

searchBestMove([Move1,_|OtherMoves],BestMove) :-
    searchBestMove([Move1|OtherMoves],BestMove),!.

count(List1,List2,Num):-
    count(L1, List1),
    count(L2, List2),
    Num is L1 + L2.

count(0, []):-!.
count(Count, [_|Tail]):- count(TailCount, Tail), Count is TailCount + 1.

approx(Num,Dec,Res):- Num >= 0, Res is floor(10^Dec*Num)/10^Dec, !.

approx(Num,Dec,Res):- Num <0, Res is ceil(10^Dec*Num)/10^Dec, !.

reversedAux([],Temp,Temp):-!.
reversedAux([Head|Tail],Temp,ReversedList):-reversedAux(Tail,[Head|Temp],ReversedList).
reversedList(List,ReversedList):-reversedAux(List,[],ReversedList).

existsFinal(R,C,[[R1,C1]|[]]):- R == R1, C == C1.
existsFinal(R,C,[[R1,C1]|_]):- R == R1, C == C1.
existsFinal(R,C,[_|Tail]):- existsFinal(R,C,Tail).