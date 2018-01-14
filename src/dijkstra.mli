(**
Ce module représente toutes les fonctions utiles pour
l'application de l'algorithme de Dijkstra.
*)

(* [dijkstra] représente le type des noeuds du graphe pour Dijkstra *)
type dijkstra

(*
[empty] représente l'ensemble vide

@requires : rien
@ensures : retourne l'ensemble vide
@raises : rien
*)
val empty : dijkstra

(*
[initialisation_dijkstra src g] initialise un ensemble de type dijkstra
avec [src] comme noeud de départ

@requires :
  [src] un string
  [g] une valeur de type graph
@ensures :
  retourne [sol] une liste telle que [sol_i] le i-ièmede élément est de
  de la forme [(n,k,weight,bool)] où
    - [n] un string représentant le prédécesseur
    - [k] un string représentant le noeud courant
    - [weight] un int représentant le poids entre le noeud de départ et celui-ci
    - [bool] un boolean représentant le fait d'être déjà passé ou non sur le noeud
@raises : rien
*)
val initialisation_dijkstra : string -> Graph.graph -> dijkstra

(*
[find_min_dijkstra tab g] détermine le noeud le plus rapidement atteignable
et indique que le noeud en question a été parcourue

@requires :
  [tab] une valeur de type dijkstra
  [g] une valeur de type graph
@ensures :
  retourne la Map actualisée ainsi que le noeud parcouru
@raises : rien
*)
val find_min_dijkstra : dijkstra -> Graph.graph -> dijkstra * (string * string * int * bool)

(*
[maj_distance init last g] actualise les poids de chaque noeud

@requires :
  [init] une valeur de type dijkstra
  [last] un tuple (string * string * int * bool)
  [g] une valeur de type graph
@ensures :
  retourne la liste de tuple actualisée
@raises : Not_found s'il ne trouve pas le noeud (donc un chemin non valide)

Cette fonction se charge d'actualiser les distances entre le noeud de départ
et les différents noeuds atteignables.
*)
val maj_distance : dijkstra -> (string * string * int * bool) -> Graph.graph -> dijkstra

(*
[dijkstra src dest g] applique l'algorithme de Dijkstra grâce aux fonctions
précédentes

@requires :
  [src] un string
  [dest] un string
  [g] une valeur de type graph
@ensures :
  retourne une Map réprésentant la conclusion de l'algorithme de Dijkstra
@raises : Not_found (par le biais de [maj_distance init last g])
*)
val dijkstra : string -> string -> Graph.graph -> dijkstra

(*
[distance tab node] renvoie la distance finale

@requires :
  [tab] une valeur de type dijkstra
  [node] un string
@ensures :
  un entier représentant la distance totale parcourue
@raises : rien
*)
val distance : dijkstra -> string -> int

(*
[path tab src dest] retourne une liste représentant le chemin entre
[src] et [dest]

@requires :
  [tab] une valeur de type dijkstra
  [src] un string
  [dest] un string
@ensures :
  une liste de noeuds représentant l'ordre dans laquelle on passe de la source
    à la destination.
@raises : Not_found dans le cas où l'algorithme n'a pas pu proposer de chemin
*)
val path : dijkstra -> string -> string -> string list
