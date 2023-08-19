#const num_partite = 10. %10
#const num_giornate = 38. %38
#const num_derby = 4. %4 per il facoltativo
#const distanza_ritorno_minima = 10. %10 per il facoltativo

squadra(juventus;milan;inter;napoli;lazio;roma;fiorentina;atalanta;sassuolo;
        verona;torino;udinese;empoli;bologna;spezia;sampdoria;cagliari;genoa;
        venezia;salernitana).

in(juventus, torino).
in(torino, torino).
in(milan, milano).
in(inter, milano).
in(napoli, napoli).
in(lazio, roma).
in(roma, roma).
in(fiorentina, firenze).
in(atalanta, bergamo).
in(sassuolo, sassuolo).
in(verona, verona).
in(udinese, udine).
in(empoli, empoli).
in(bologna, bologna).
in(spezia, laspezia).
in(sampdoria, genova).
in(cagliari, cagliari).
in(genoa, genova).
in(venezia, venezia).
in(salernitana, salerno).

giornata(1..num_giornate). 

%2
%la partita si tiene nella casa della prima squadra.
num_partite {partita(G, S1, S2):squadra(S1), squadra(S2), S1!=S2} num_partite :- giornata(G).


%3
%una squadra non può giocare più di una volta nella stessa giornata
numeroPartiteGiornata(G, S1, Conteggio):-giornata(G), squadra(S1), 
                        Conteggio1 = #count{S2: partita(G, S1, S2)}, Conteggio2 = #count{S2: partita(G, S2, S1)},
                        Conteggio = Conteggio1+Conteggio2.

:-giornata(G), squadra(S), numeroPartiteGiornata(G,S,Conteggio), Conteggio > 1.
%-----------------------------------------------------------------------------------

%4
%ogni squadra affronta due volte tutte le altre squadre, una volta in casa e una
%volta fuori casa, ossia una volta nella propria città di riferimento e una volta in
%quella dell’altra squadra;
%:-squadra(S1), squadra(S2), S1 != S2, Sum = #count{G: partita(G, S1, S2)}, Sum != 1.
%-----------------------------------------------------------------------------------

%5
%due squadre della stessa città condividono la stessa struttura di gioco, quindi
%non possono giocare entrambe in casa nella stessa giornata;
:-in(S1, C), in(S2, C), partita(G, S1, S3) , partita(G, S2, S4), S1!=S2.
%-----------------------------------------------------------------------------------

%7
%ci sono 3 derby, ossia 3 coppie di squadre che fanno riferimento alla medesima
%città (4 nel nel caso facoltativo).
:-Conteggio = #count{S1, S2: squadra(S1), squadra(S2), in(S1, C), in(S2, C), S1 != S2, partita(G, S1, S2)}, Conteggio/2 != num_derby.
%-----------------------------------------------------------------------------------


%6
%ciascuna squadra non deve giocare mai più di due partite consecutive in casa o
%fuori casa;     
:-giornata(G1), G2 = G1 + 1, G3 = G2 + 1, partita(G1, S1, S2), partita(G2, S1, S3), partita(G3, S1, S4). 
:-giornata(G1), G2 = G1 + 1, G3 = G2 + 1, partita(G1, S2, S1), partita(G2, S3, S1), partita(G3, S4, S1).     
%-----------------------------------------------------------------------------------

%8
%la distanza tra una coppia di gare di andata e ritorno è di almeno 10 giornate,
%ossia se SquadraA vs SquadraB è programmata per la giornata 12, il ritorno
%SquadraB vs SquadraA verrà schedulato non prima dalla giornata 22.
:-partita(G1, S1, S2), partita(G2, S2, S1), G2>G1, Distanza = G2-G1, Distanza < distanza_ritorno_minima.
%-----------------------------------------------------------------------------------

#show partita/3.
