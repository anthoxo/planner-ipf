(**
Ce module représente toutes les fonctions utiles pour
l'application de l'algorithme de Dijkstra.
*)

(* ceci représente le type des noeuds du graphe pour Dijkstra *)
type dijkstra

(**
@requires : rien
@ensures : ensemble vide
@raises : rien
*)
val empty : dijkstra

(**
@requires :
  un élément de type String (représentant le noeud de départ)
  un graphe
@ensures :
  retourne une liste de tuple dont les tuples sont composés :
    - du noeud
    - d'un poids représentant la distance entre ce noeud et celui de départ
    - d'un boolean permettant de savoir si ce noeud a été parcouru ou non
    - d'un noeud représentant son prédécesseur s'il existe (sinon "")
  Nous nommerons cette liste de tuple dans la suite
  la liste représentant la progression dans l'algorithme de Dijkstra.
@raises : rien

Cette fonction initialise la liste de progression.
*)
val initialisation_dijkstra : string -> Graph.graph -> dijkstra

(**
@requires :
  une liste de tuples représentant la progression dans l'algorithme
  un graphe
@ensures :
  retourne la liste de tuple actualisée
@raises : rien

Cette fonction trouve le noeud atteignable le plus rapidement possibe et
indique que le noeud en question a été parcouru.
Elle se charge également de trier la liste en faisant en sorte que les éléments
déjà parcourus se retrouvent en fin de liste.
*)
val find_min_dijkstra : dijkstra -> Graph.graph -> dijkstra * (string * string * int * bool)

(**
@requires :
  une liste de tuples représentant la progression dans l'algorithme
  un graphe
@ensures :
  retourne la liste de tuple actualisée
@raises : rien

Cette fonction se charge d'actualiser les distances entre le noeud de départ
et les différents noeuds atteignables.
*)
val maj_distance : dijkstra -> (string * string * int * bool) -> Graph.graph -> dijkstra

(**
@requires :
  un noeud de départ
  un noeud d'arrivée
  un graphe
@ensures :
  une liste de tuples représentant les distances entre un noeud et celui de départ.
@raises : rien

Cette fonction applique l'algorithme de Dijkstra.
*)
val dijkstra : string -> string -> Graph.graph -> dijkstra

(**
@requires :
  une liste de tuples représentant la progression dans l'algorithme
  un noeud d'arrivée
@ensures :
  un entier représentant la distance totale parcourue
@raises : Empty dans le cas où l'algorithme n'a pas pu proposer de chemin
*)
val distance : dijkstra -> string -> int

(**
@requires :
  une liste de tuples représentant la progression dans l'algorithme
  un noeud de départ
  un noeud d'arrivée
@ensures :
  une liste de noeuds représentant l'ordre dans laquelle on passe de la source
    à la destination.
@raises : Empty dans le cas où l'algorithme n'a pas pu proposer de chemin
*)
val path : dijkstra -> string -> string -> string list
