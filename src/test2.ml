#cd "analyse/";;
#load "analyse.cmo";;
open Analyse;;
#cd "../graph/";;
#load "edge.cmo";;
open Edge;;
#load "graph.cmo";;
open Graph;;
#load "dijkstra.cmo";;
open Dijkstra;;
#cd "../queue/";;
#load "planning.cmo";;
open Planning;;
#cd "../";;

(**
Ce module représente tous les tests pour la partie 2
*)

let g = Graph.empty;;
let (list_graph,path) = analyse_file_2 "test/txt/2.txt";;
let g = Graph.add_edge_list list_graph g;;
let (a,n) = fill_all path Planning.empty g;;
let t = Planning.queue_to_list a;;
let a = Planning.update a;;
let t = Planning.queue_to_list a;;

let (liste, (_,b)) = Analyse.analyse_file_1 "test/txt/test1.txt";;
let g = Graph.add_edge_list liste Graph.empty;;
let path = [["s";"d";"c";"b";"a";"t"];["s";"a";"b";"c";"d";"t"]];;
let (a,n) = fill_all path Planning.empty g;;
let t = Planning.queue_to_list a;;
let a = Planning.update a;;
let t = Planning.queue_to_list a;;
let li = Planning.split_queue a n;;
