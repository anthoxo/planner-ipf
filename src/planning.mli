(**
Ce module représente tout ce qui concerne la planification
et la détermination des personnes passant les modules
du vaisseau.
*)

(** ceci représente le type de la file *)
type queue

(**
@requires : rien
@ensures : retourne la file vide
@raises : rien
*)
val empty : queue

(**
@requires : une file
@ensures : retourne true si la file est vide, false sinon
@raises : rien
*)
val is_empty : queue -> bool

(**
@requires :
  un entier n
  une arête e
  un entier i
  un entier j
  une file
@ensures : retourne la file avec (n,e,i,j) en plus
@raises : rien
*)
val add : int -> Graph.edge -> Graph.graph -> int -> int -> queue -> queue

(**
@requires :
  un entier n
  une liste de chaînes de caractères
  une file
  un graphe
@ensures : retourne la file où on ajoute les arêtes d'un chemin donné
@raises : Empty si la liste est vide
*)
val fill : int -> string list -> int -> Graph.graph -> queue -> queue

(**
@requires :
  une liste de listes de chaînes de caractères
  une file
  un graphe
@ensures : retourne la file où on ajoute les arêtes d'une liste de chemin
@raises : rien
*)
val fill_all : string list list -> Graph.graph -> queue -> queue * int

(**
@requires :
  une file
@ensures : retourne la file transformée en liste
@raises : rien
*)
val queue_to_list : queue -> (int * (int * string * string * int * int) list) list


val print_queue : queue -> unit
val check : Graph.graph -> queue -> (string * string * int list) list



(**
@requires :
  un entier n
  un entier weight
  une file
@ensures :
  retourne la file où les éléments d'un chemin n ont leurs poids
  augmenté de weight
@raises : rien
*)
val update_weight : int -> int -> int -> Graph.graph -> queue -> queue

(**
@requires :
  une file
@ensures :
  construit une file en tenant compte du fait qu'il n'y a qu'un
  passager par tunnel (arête)
@raises : rien
*)
val update : Graph.graph -> queue -> queue

val split_queue : queue -> int -> (int * string * string * int * int) list list
