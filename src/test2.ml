(**
Ce module représente tous les tests pour la partie 2
*)

(** let g = Graph.empty;;
let (list_graph,path) = Analyse.analyse_file_2 "test/2.txt";;
let g = Graph.add_edge_list list_graph g;;
let (a,n) = Planning.fill_all path g Planning.empty;;
let t = Planning.queue_to_list a;;
let a = Planning.update g a;;
let t = Planning.queue_to_list a;;
**)
let (liste, (_,b)) = Analyse.analyse_file_1 "test/test1.txt";;
let g = Graph.add_edge_list liste Graph.empty;;
let path = [["s";"d";"c";"b";"a";"t"];["s";"a";"b";"c";"d";"t"]];;
let (a,n) = Planning.fill_all path g Planning.empty;;
let t = Planning.queue_to_list a;;
let _ = Planning.print_queue a;;
let tmp = Planning.check g a;;
(** List.fold_left (
  fun _ (a,b,li) ->
    let _ = print_string (a^","^b^"--> [") in
    List.fold_left (
      fun _ i -> print_string ((string_of_int i)^";")
      ) () li
  ) () tmp;; **)

let a = Planning.update g a;;
let t = Planning.queue_to_list a;;
let li = Planning.split_queue a n;;
