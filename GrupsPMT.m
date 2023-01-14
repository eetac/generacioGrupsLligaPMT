% Grups Lliga PMT: sorteig tenint en compte l'històric

%Paràmetres d'entrada

Num_nivells=8;   % 8 jugadors per nivell, excepte possible nivell baix de 4 jugadors
Hi_ha_grup_unic_baix=1;  % 1=hi ha només un grup baix de tot, 0=Hi ha dos grups al nivell inferior
Noms_grups=[{'A1'},{'A2'},{'B1'},{'B2'},{'C1'},{'C2'},{'D1'},{'D2'},{'E1'},{'E2'},{'F1'},{'F2'},{'G1'},{'G2'},{'H'}]; 
Primera_assignacio=0;  % 1=és la primera assiganció després d'una fase prèvia. 0=no és la primera assignació o no hi ha hagut prèvia
Noms_Jugadors=readtable('NomsJugadors.dat'); %Han d'estar per ordre de numero de jugador, coherent amb matriu de l'històric
Jugadors_nivell=readtable('NivellsJugadors.dat');  %Codis dels jugadors en cada nivell. Han d'estar per ordre: els 8 primers A, els 8 segons B, etc,
                                                   %Els dos primers i els dos últims de cada nivell no poder coincidir (només els
                                                   %dos últims pels nivells superior i inferior)                                                   
Historic=readmatrix('HistoricCoincidencies.dat');  %Cada columna i fila és un jugador, ha de ser coherent amb els codis. Només triangle superior.
                                                   %IMPORTANT: La primera columna és un índex,NO es fa servir


% Inicialització

Combi_final=zeros(4,Num_nivells,2);  %Combinacions triades finals (output)
Combi_final_codis=zeros(4,Num_nivells,2);   %Codis jugadors combinacions triades (output)
clear Combi_final_noms
rng('shuffle');  % reiniciem llavor nombres aleatoris

Combinacions=[1,1,2,2,1,1,2,2,1,1,2,2,1,1,1,1,1,1,1,1;   %Combinacions possibles
              3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2;
              4,4,4,4,5,5,5,5,6,6,6,6,3,3,4,4,5,5,6,6;
              7,8,7,8,7,8,7,8,7,8,7,8,7,8,7,8,7,8,7,8];
Combinacions2=[2,2,1,1,2,2,1,1,2,2,1,1,4,4,3,3,3,3,3,3;
               5,5,5,5,4,4,4,4,4,4,4,4,5,5,5,5,4,4,4,4;
               6,6,6,6,6,6,6,6,5,5,5,5,6,6,6,6,6,6,5,5;
               8,7,8,7,8,7,8,7,8,7,8,7,8,7,8,7,8,7,8,7];

Combinacions_ini=[1,1,1;  %Per fer els primers grups després de la prèvia (si n'hi ha) cal repartir 2 de cada posició a cada grup
                  3,4,4;  %Hi ha 3 combinacions possibles. S'han de posar alterns els primers i segons
                  6,5,6;  %de cada grup. 1rA1, 2nA1, 1rA2, 2nA2, 1rB1, etc. El mateix amb 3r i 4rt 
                  8,8,7]; 
Combinacions2_ini=[2,2,2;
                   4,3,3;
                   5,6,5;
                   7,7,8];


                                                  

%Assignació grups

for nivell=1:Num_nivells
    if (Primera_assignacio==1)
        num_combis=3;
    else   
        if (or(nivell==1, nivell==Num_nivells))
            num_combis=20;   %Grups límit (dalt i baix)
        else
            num_combis=12;   %Grups intermitjos
        end
    end

    if (and(Hi_ha_grup_unic_baix==1,nivell==Num_nivells))  %Estem en el nivell baix únic
        Jugadors=Jugadors_nivell.Jugador((((nivell-1)*8)+1):(((nivell-1)*8)+4));  %Jugadors corresponents al nivell inferior
        Combi_final_codis(1:4,nivell,1)=Jugadors(1:4);  %Codis jugadors corresponents
        Combi_final_codis(1:4,nivell,2)=zeros(1,4); %No hi ha segon grup del  nivell inferior
        Combi_final_noms(1:4,(nivell*2-1))=string(Noms_Jugadors.NomJugador(Combi_final_codis(1:4,nivell,1))+" "+string(Combi_final_codis(1:4,nivell,1)));   %Noms jugadores de grups en columna   
    else

        Jugadors=Jugadors_nivell.Jugador((((nivell-1)*8)+1):(((nivell-1)*8)+8));  %Jugadors (codis) corresponents al nivell
        Pes=zeros(num_combis,1);   % Ponderació: suma de coincidències dels jugadors a la combinació i
    
        for i=1:num_combis   %Repassem totes les combinacions possibles i creem matriu coincidències Combin(8,8)
            Combin=zeros(8,8);  % Matriu de coincidències per cada parella de jugadors (8x8). Només fem servir triangle superior
            esta=zeros(2,1);  % Control (flag) de si estan els dos que busco (esta(1) al grup X1, esta(2) al grup X2)
            for n=1:7  %Busco jugador n
                for j=1:4    %Busco en les 4 posicions de la combinació
                    if (Combinacions(j,i)==n)  %Posició j, combinació i
                        esta(1)=1;  %El jugador n sí està  a la combinació i grup X1
                    end
                end
                for m=n+1:8   %Ara busco el jugador m
                    for j=1:4  %Busco en les 4 posicions de la combinació
                        if (Combinacions(j,i)==m)  %Posició j, combinació i
                            esta(2)=1;  %El jugador m sí està  a la combinació i grup X2
                        end
                    end
                    if (or(esta(1)==1 & esta(2)==1, esta(1)==0 & esta(2)==0))
                        Combin(n,m)=1;       %Jugadors n i m estan al mateix grup en aquesa combinació
                    end
                    esta(2)=0;  %Esborrem flag i busquem següent m
                end    
                esta(1)=0;  %Esborrem flag i busquem següent n
            end
            for n=1:7   %Per cada jugador n
                for m=n+1:8   %Per cada jugador m
                    if (Combin(n,m)==1)  %Si els jugadors n,m estan junts, sumem històric
                        if (Jugadors(n)<Jugadors(m))
                            Pes(i)=Pes(i)+Historic(Jugadors(n),Jugadors(m)+1);  %Sumem 1 columna perquè la primera és l'índex
                        else
                            Pes(i)=Pes(i)+Historic(Jugadors(m),Jugadors(n)+1);  %Sumem 1 columna perquè la primera és l'índex
                        end
                    end
                end
            end
        end
        num_opt=0;
        select_opt=zeros(num_combis,1);
        Min_pes=min(Pes);   %Valor optim (mínim) ponderació
        for i=1:num_combis    %repassem totes les combinacions
            if (Pes(i)==Min_pes)   %Mirem si la i és una de les òptimes
                num_opt=num_opt+1;
                select_opt(num_opt)=i;  %Guardem les posicions de les combinacions òptimes
            end
        end
        sorteig=randi(num_opt);  %Sorteig entre les opcions òptimes
        C_final=select_opt(sorteig);   %Número de la combinació seleccionada
        Combi_final(1:4,nivell,1)=Combinacions(1:4,C_final);  %Grups X1 a la columna del nivell corresponent
        Combi_final(1:4,nivell,2)=Combinacions2(1:4,C_final); %Grups X2 a la columna del nivell corresponent
        Combi_final_codis(1:4,nivell,1)=Jugadors(Combinacions(1:4,C_final));  %Codis jugadors corresponents X1
        Combi_final_codis(1:4,nivell,2)=Jugadors(Combinacions2(1:4,C_final)); %Codis jugadores corresponents X2
        Combi_final_noms(1:4,(nivell*2-1))=string(Noms_Jugadors.NomJugador(Combi_final_codis(1:4,nivell,1))+" "+string(Combi_final_codis(1:4,nivell,1)));   %Noms jugadores de grups per columnes
        Combi_final_noms(1:4,nivell*2)=string(Noms_Jugadors.NomJugador(Combi_final_codis(1:4,nivell,2))+" "+string(Combi_final_codis(1:4,nivell,2)));   % X1, X2, Y1, Y2, etc.
    end
end
Combi_final_noms  %Mostrem en pantalla el resultat final
writematrix ([Noms_grups;Combi_final_noms], 'ResultatGrups.dat'); %El guardem al fitxer de sortida


%Actualització històric

for nivell=1:Num_nivells
    for n=1:3
        for m=n+1:4
            if (Combi_final_codis(n,nivell,1)<Combi_final_codis(m,nivell,1))
                Historic(Combi_final_codis(n,nivell,1),Combi_final_codis(m,nivell,1)+1)=Historic(Combi_final_codis(n,nivell,1),Combi_final_codis(m,nivell,1)+1)+1; %Sumem 1 columna perquè la primera és l'índex
            else
                Historic(Combi_final_codis(m,nivell,1),Combi_final_codis(n,nivell,1)+1)=Historic(Combi_final_codis(m,nivell,1),Combi_final_codis(n,nivell,1)+1)+1; %Sumem 1 columna perquè la primera és l'índex
            end
            if (or(Hi_ha_grup_unic_baix==0,nivell<Num_nivells))
                if (Combi_final_codis(n,nivell,2)<Combi_final_codis(m,nivell,2))
                    Historic(Combi_final_codis(n,nivell,2),Combi_final_codis(m,nivell,2)+1)=Historic(Combi_final_codis(n,nivell,2),Combi_final_codis(m,nivell,2)+1)+1; %Sumem 1 columna perquè la primera és l'índex
                else
                    Historic(Combi_final_codis(m,nivell,2),Combi_final_codis(n,nivell,2)+1)=Historic(Combi_final_codis(m,nivell,2),Combi_final_codis(n,nivell,2)+1)+1; %Sumem 1 columna perquè la primera és l'índex
                end
            end
        end
    end
end

writematrix (Historic, 'HistoricCoincidenciesOUT.dat');  % Canviar nom fitxer abans de tornar a executar la següent ronda


    