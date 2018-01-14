(* Ce module représente la structure de graphe  *)

(* [node] représente le type des nœuds *)
type node

(* [edge] représente le type des arêtes *)
type edge

(* [graph] représente le graphe en lui-même *)
type graph

(*
[edge src dest] construit une arête à partir de deux chaînes de caractères

@requires : [src] et [dest] des strings
@ensures : une valeur de type edge
@raises : rien
*)
val edge : string -> string -> edge

(*
[edge_split (a,b)] renvoie un couple de strings.

@requires : [(a,b)] une valeur de type edge
@ensures : un couple de strings
@raises : rien
*)
val edge_split : edge -> string * string

(*
[empty] représente le graphe vide

@requires : rien
@ensures : retourne le graphe vide
@raises : rien
*)
val empty : graph

(*
[is_empty g] vérifie si le graph est vide ou non

@requires : [g] est une valeur de type graph
@ensures : retourne true si le graphe est vide, false sinon
@raises : rien
*)
val is_empty : graph -> bool

(*
[cardinal g] retourne le nombre de noeuds dans ce graphe
@requires : [g] est une valeur de type graph
@ensures : retourne le nombre de noeuds dans ce graphe
@raises : rien
*)
val cardinal : graph -> int

(*
[mem_node n g] vérifie si un noeud [n] se trouve dans un graphe [g]

@requires :
  [n] est un string
  [g] est une valeur de type graph
@ensures :
  retourne true si le noeud se trouve dans le graphe,
  retourne false sinon
@raises : rien
*)
val mem_node : string -> graph -> bool

(*
[add_edge (n1,n2) weight g] ajoute une arête [(n1,n2)] dans un graphe [g]

@requires :
  [(n1,n2)] une valeur de type edge
  [weight] un entier représentant l'étiquette de l'arête
  [g] une valeur de type graph
@ensures :
  retourne le graphe avec le nouvel arc s'il n'y est pas
  sinon renvoit le graphe inchangé
@raises : rien
*)
val add_edge : edge -> int -> graph -> graph

(*
[add_edge_list li g] ajoute les arêtes de la liste [li]

@requires :
  [li] une liste de (string * string * 'a)
  [g] une valeur de type graph
@ensures :
  retourne le graphe avec les nouvelles arêtes
@raises : rien
*)
val add_edge_list : (string * string * int) list -> graph -> graph

(*
[find_edge (n1,n2) g] retourne l'étiquette d'une arête, -1 sinon
@requires :
  [(n1,n2)] une valeur de type edge
  [g] une valeur de type graph
@ensures :
  retourne l'étiquette de l'arête,
  retourne -1 si l'arête n'est pas dans le graphe
@raises : rien
*)
val find_edge : edge -> graph -> int

(*
[fold f g acc] applique la méthode fold du module Map

@requires :
  [f] une fonction de type (key -> 'a -> 'b -> 'b)
  [g] une valeur de type graph
  [acc] un accumulateur de type 'b
@ensures :
  applique la fonction fold de MapGraph
@raises : rien
*)
val fold : (string -> node -> 'b -> 'b) -> graph -> 'b -> 'b

(*
[distance_path li g] calcule la distance parcourue par un chemin [li]

@requires :
  [li] une liste
  [g] une valeur de type graph
@ensures :
  calcule la distance selon une liste
@raises : rien
*)
val distance_path : string list -> graph -> int
