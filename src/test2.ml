(**
Ce module représente tous les tests pour la partie 2
*)

let g = Graph.empty;;
let (list_graph,path) = Analyse.analyse_file_2 "test/txt/2.txt";;
let g = Graph.add_edge_list list_graph g;;
let (a,n) = Planning.fill_all path g Planning.empty;;
let t = Planning.queue_to_list a;;
let a = Planning.update g a;;
let t = Planning.queue_to_list a;;

let (liste, (_,b)) = Analyse.analyse_file_1 "test/txt/test1.txt";;
let g = Graph.add_edge_list liste Graph.empty;;
let path = [["s";"d";"c";"b";"a";"t"];["s";"a";"b";"c";"d";"t"]];;
let (a,n) = Planning.fill_all path g Planning.empty;;
let t = Planning.queue_to_list a;;
let a = Planning.update g a;;
let t = Planning.queue_to_list a;;
let li = Planning.split_queue a n;;
