(**
Ce module représente tous les tests pour la partie 1
*)

(**
Test de vacuité
*)
let g = Graph.empty;;
let _ = Graph.is_empty g;;

let g = Graph.add_edge (Graph.edge "n1" "n2") 30 g;;
let _ = Graph.is_empty g;;
let _ = Graph.cardinal g;;

(**
Remplissage par les foncions du module Analyse
*)
let g = Graph.empty;;
let (liste, (a,b)) = Analyse.analyse_file_1 "test/1.txt";;
let g = Graph.add_edge_list liste g;;
let _ = Graph.is_empty g;;
let _ = Graph.cardinal g;;

let g = Graph.empty;;
let (liste, (a,b)) = Analyse.analyse_file_1 "test/test1.txt";;
let g = Graph.add_edge_list liste g;;
let _ = Graph.cardinal g;;
let _ = Graph.mem_node "n0" g;;
let _ = Graph.mem_node "n1" g;;
let _ = Graph.mem_node "a" g;;

let _ = Graph.find_edge (Graph.edge "a" "f") g;;
let _ = Graph.find_edge (Graph.edge "a" "s") g;;
let _ = Graph.find_edge (Graph.edge "s" "a") g;;


let g = Graph.empty;;
let (liste, (a,b)) = Analyse.analyse_file_1 "test/4.txt";;
let g = Graph.add_edge_list liste g;;
let tab = Dijkstra.dijkstra a b g;;

let _ = Analyse.output_sol_1 (Dijkstra.distance tab b) (Dijkstra.path tab a b);;

let test f a b g =
  let t1 = Sys.time () in
  let rec aux f n =
    match n with
      |0 -> ()
      |n -> let _ = (f a b g) in aux f (n-1)
  in
  let _ = aux f 10000 in
  let t2 = Sys.time () in
  print_float (t2-.t1);;

test (Dijkstra.dijkstra) a b g;;
