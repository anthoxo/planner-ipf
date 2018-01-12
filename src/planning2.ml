module MapQueue = Map.Make(struct type t = int let compare = compare end);;
type queue = (int * string * string * int * int) list MapQueue.t

exception Empty;;

let empty = MapQueue.empty;;

let is_empty q = MapQueue.is_empty;;

let add n edge g p1 p2 total q =
  let weight = Graph.find_edge edge g in
  if (weight = -1)
  then
    q
  else
    let (a,b) = Graph.edge_split edge in
    let tmp =
      try
        MapQueue.find p1 q
      with
      | Not_found -> []
    in
    MapQueue.add p1 (n,a,b,p2,total)::tmp q
  ;;

let remove_empty_value q =
  MapQueue.fold
    (
      fun k v acc ->
        if (v = []) then MapQueue.remove k acc
        else acc
    ) q q

let fill n path total q g =
  let rec aux n path node acc q g =
    match path with
      |[] -> q
      |t::s ->
        let weight = Graph.find_edge (Graph.edge t node) g in
        if weight = -1
        then
          assert false
        else
          let priority = acc + weight in
          aux n s t priority (add n (Graph.edge t node) acc priority total q) g
  in
  match path with
    |[] -> raise Empty
    |t::s -> aux n s t 0 q g;;

let fill_all li q g =
  let rec aux li acc q g =
    match li with
      |[] -> (q,acc)
      |t::s ->
        let total = Graph.distance_path t g in
        aux s (acc+1) (fill acc t total q g) g
  in
  aux li 0 q g;;

let rec queue_to_list q =
  MapQueue.bindings q;;

(* continuer update_weight *)
let update_weight n deb weight q =
  MapQueue.fold
    (
      fun k v acc ->
        if (k < deb) then acc
        else
        let rec aux l acc1 acc2 =
          match l with
            |[] -> (acc1,acc2)
            |((i,n1,n2,f,total)::s) ->
              if (i = n)
              then
                aux s acc1 (i,n1,n2,f,total)
              else
                aux s ((i,n1,n2,f,total)::acc1) acc2
        in
        let (a1,a2) = aux v [] (-1,"","",0,0) in
        let (indice,e1,e2,p,total) = a2 in
        if (indice = -1) then acc
        else
          let tmp = MapQueue.add k v acc in
          add n edge g p1 p2 total q
          add n (Graph.edge e1 e2) g (k+weight) (p+weight) (total+weight)
    ) q q

let update q =
  let rec check elt q =
    let (n1,edge1,p11,p12) = elt in
    match q with
      [] -> 0
      |(n,edge,p1,p2)::s ->
        let (e11,e12) = Graph.edge_split edge1 in
        let (e21,e22) = Graph.edge_split edge in
        if ((p12 <= p1) || (p11 >= p2))
        then
          check elt s
        else if (e11 = e21 && e12 = e22 && p11 < p2)
        then
          p2-p11
        else
          check elt s
  in
  let rec aux acc q =
    match q with
      |[] -> acc
      |(n,edge,p1,p2)::s ->
        let weight = check (n,edge,p1,p2) acc in
        if (weight = 0)
        then
          aux (add n edge p1 p2 acc) s
        else
          let q2 = update_weight n weight s in
          aux (add n edge (p1+weight) (p2+weight) acc) q2
  in
  aux [] q;;

let split_queue q nb =
  let rec aux1 i =
    match i with
      |0 ->[]
      |i -> []::(aux1 (i-1))
  in
  let rec aux2 li elt i =
    match (i,li) with
      |0,(t::s) -> let tmp = elt::t in tmp::s
      |i,[] -> raise Empty
      |i,(t::s) -> t::(aux2 s elt (i-1))
  in
  let rec aux3 q li =
    match q with
      |[] -> li
      |(n,e,p1,p2)::s -> aux3 s (aux2 li (n,e,p1,p2) n)
  in
  aux3 q (aux1 nb);;
