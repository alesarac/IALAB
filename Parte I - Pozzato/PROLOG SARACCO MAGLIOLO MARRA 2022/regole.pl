applicable(sudEst,pos(Row,Column)):-
	num_columns(NC),
    Column<NC,
    num_rows(NR),
    Row<NR,
    NextColumn is Column+1,
    NextRow is Row+1,
    \+occupied(pos(NextRow,NextColumn)).

applicable(sud,pos(Row,Column)):-
    num_rows(NR),
    Row<NR,
    NextRow is Row+1,
    \+occupied(pos(NextRow,Column)).

applicable(est,pos(Row,Column)):-
    num_columns(NC),
    Column<NC,
    NextColumn is Column+1,
    \+occupied(pos(Row,NextColumn)).

applicable(sudOvest,pos(Row,Column)):-
	Column>1,
    num_rows(NR),
    Row<NR,
    NextColumn is Column-1,
    NextRow is Row+1,
    \+occupied(pos(NextRow,NextColumn)).

applicable(nordEst,pos(Row,Column)):-
	num_columns(NC),
    Column<NC,
    Row>1,
    NextColumn is Column+1,
    NextRow is Row-1,
    \+occupied(pos(NextRow,NextColumn)).

applicable(nordOvest,pos(Row,Column)):-
	Column>1,
    Row>1,
    NextColumn is Column-1,
    NextRow is Row-1,
    \+occupied(pos(NextRow,NextColumn)).

applicable(ovest,pos(Row,Column)):-
    Column>1,
    NextColumn is Column-1,
    \+occupied(pos(Row,NextColumn)).

applicable(nord,pos(Row,Column)):-
    Row>1,
    NextRow is Row-1,
    \+occupied(pos(NextRow,Column)),!.

trasform(sudEst,pos(Row,Column),pos(R,C)):-C is Column+1, R is Row+1,!.
trasform(sud,pos(Row,Column),pos(R,Column)):-R is Row+1,!.
trasform(est,pos(Row,Column),pos(Row,C)):-C is Column+1,!.
trasform(sudOvest,pos(Row,Column),pos(R,C)):-C is Column-1, R is Row+1,!.
trasform(nordEst,pos(Row,Column),pos(R,C)):-C is Column+1, R is Row-1,!.
trasform(nordOvest,pos(Row,Column),pos(R,C)):-C is Column-1, R is Row-1,!.
trasform(ovest,pos(Row,Column),pos(Row,C)):-C is Column-1,!.
trasform(nord,pos(Row,Column),pos(R,Column)):-R is Row-1,!.