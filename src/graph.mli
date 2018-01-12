(**
Ce module représente le graphe en lui-même
*)

(** ceci représente le type des nœuds *)
type node

(** ceci représente le type des arêtes *)
type edge

(* ce type représente le graphe en lui-même *)
type graph

(**
@requires : deux chaînes de caractères
@ensures : une arête
@raises : rien
*)
(** elle construit une arête à partir de deux chaînes de caractères *)
val edge : string -> string -> edge

(**
@requires : une arête
@ensures : deux chaînes de caractères
@raises : rien
*)
val edge_split : edge -> string * string

(**
@requires : rien
@ensures : retourne le graphe vide
@raises : rien
*)
val empty : graph

(**
@requires : un graphe
@ensures : retourne true si le graphe est vide, false sinon
@raises : rien
*)
val is_empty : graph -> bool

(**
@requires : un graphe
@ensures : retourne le nombre de nœuds dans ce graphe
@raises : rien
*)
val cardinal : graph -> int

(**
@requires :
  un string représentant un nœud
  un graphe
@ensures :
  retourne vrai si le nœud se trouve dans le graphe,
  retourne faux sinon
@raises : rien
*)
val mem_node : string -> graph -> bool

(**
@requires :
  une clé représentant une arête à ajouter dans un graphe
  une valeur (entier) représentant l'étiquette d'une arête
  un graphe
@ensures :
  retourne le graphe avec le nouvel arc s'il n'y est pas
    sinon renvoit le graphe inchangé
  ajoute les nœuds s'ils ne sont pas dans la liste des nœuds
@raises : rien
*)
(* cette méthode se charge d'ajouter une arête à un graphe *)
val add_edge : edge -> int -> graph -> graph

(**
@requires :
  une liste de type (string * string * 'a) contenant deux nœuds
    pour l'arête avec son étiquette
  un graphe
@ensures :
  retourne le graphe avec les nouvelles arêtes
  ajoute les nœuds s'ils ne sont pas dans la liste
@raises : rien
*)
val add_edge_list : (string * string * int) list -> graph -> graph

(**
@requires :
  un élément de type Edge (string * string)
  un graphe
@ensures :
  retourne l'étiquette de l'arête,
  retourne -1 si l'arête n'est pas dans le graphe
@raises : Not_found (dans le cas où l'arête n'est pas dans le graphe)
*)
val find_edge : edge -> graph -> int

(**
@requires :
  une fonction f (key -> 'a -> 'b -> 'b)
  un graphe
@ensures :
  applique la fonction fold de MapGraph
@raises : rien
*)
val fold : (string -> node -> 'b -> 'b) -> graph -> 'b -> 'b

(**

*)
val distance_path : string list -> graph -> int
