
GrupsPMT.m  : codi Matlab a executar

# Fitxers d'entrada:

* NomsJugadors.dat   : Fitxer on s'indica el codi (número) que correspon a cada jugador (nom)
* NivellsJugadors.dat   : Fitxer on s'indica a quin nivell jugarà cada jugador (codi) en la següent ronda
* HistoricCoincidencies.dat : Fitxer on es guarda l'històric de coincidències de cada jugador amb la resta de jugadors

# Fitxers de sortida (es creen a l'executar el .m)

* HistoricCoincidenciesOUT.dat  :  sortida amb el nou (actualitzat) fitxer de coincidències. 
* ResultatGrups.dat  :   sortida amb el resultat dels grups nous. Són camps separats per comma (,). És recomanable obrir-lo amb un editor de fulles de càlcul

# Fitxers auxiliars (poden no fer-se servir)

* HistoriCoindicenciesOLD.dat  :  Fitxer (opcional) os es guarden les coincidències de la ronda anterior, per si de cas
* NivellsJugador plantilla.dat  :  Fitxer amb l'estructura corresponent a NivellsJugador.dat afegint text addicional explicatiu per indicar on va cada jugador. Es pot omplir el fitxer NivellsJugadors.dat a partir d'una còpia d'aquest fitxer, en aquest cas cal esborrar el text auxiliar addicional abans d'executar el .m


#Passes a seguir:

* Posar tots els fitxers en una mateixa carpeta i fer-la carpeta activa a Matlab

* Si hi ha nous jugadors que no estan a NomsJugadors.dat (encara que hi hagi baixes) cal afegir els nous jugadors al fitxer NomsJugadors.dat, al final de tot, amb numeració correlativa. Per cada nou jugador CAL AFEGIR TAMBÉ les corresponents files i columnes (",0"), al fitxer HistoricCoincidencies.dat. Aquest fitxer ha de tenir una matriu quasi-quadrada: Si hi ha N jugadors a NomJugadors.dat el fitxer ha de tenir N files i N+1 columnes. Hi ha una columna addicional que és l'index, per comoditat de lectura del fitxer.

* Omplir les dades del fitxer NivellsJugadors.dat, segons els resultats i seguint els codis corresponents segons el fitxer NomsJugadors.dat

* Executar GrupsPMT.m

* Obrir ResultatsGrups.dat amb un Full de Càlcul, revisar resultats.

* Canviar el noms dels fitxers: "HistoricCoincidencies.dat" -> "HistoricCoincidenciesOLD.dat" ; "HistoricCoincidenciesOUT.dat" -> "HistoricCoincidencies.dat"


AUTHOR: Luis Alonso
Comité dels AVIS LLIGAPMT
