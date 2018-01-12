module MapDijkstra = Map.Make(String);;

type dijkstra = (string * string * int * bool) MapDijkstra.t;;

let empty = MapDijkstra.empty;;

let initialisation_dijkstra src g =
  let d = Graph.fold
    (
      fun k v acc ->
        if (String.compare k src = 0) then MapDijkstra.add k ("",k,0,false) acc
        else MapDijkstra.add k ("",k,max_int,false) acc
    ) g MapDijkstra.empty
  in d;;

let find_min_dijkstra tab g =
  let (pred,k,w,_) =
    MapDijkstra.fold
      (
        fun k (pred,_,weight,b) acc ->
          match b with
            |true -> acc
            |false ->
              let (_,_,d,_) = acc in
              if weight < d then (pred,k,weight,b)
              else acc
      ) tab ("","",max_int,false)
  in
  (MapDijkstra.add k (pred,k,w,true) tab, (pred,k,w,true));;

exception Not_found;;

let maj_distance init last g =
  let (_, pred,weight,_) = last in
  MapDijkstra.fold
    (
      fun k v acc ->
        let (p1,_,w1,b) = v in
        if b then acc
        else
          let d = Graph.find_edge (Graph.edge k pred) g in
          match (d,w1) with
            |(-1,_) -> MapDijkstra.add k v acc
            |(d1,d2) ->
              if (d2 > d1 + weight)
              then
                MapDijkstra.add k (pred,k,d1+weight,b) acc
              else
                MapDijkstra.add k v acc
    ) init init;;

exception Empty;;

let dijkstra src dest g =
  let rec aux pred g res acc1 =
    match res with
      |true -> acc1
      |false ->
        let (init,a) = find_min_dijkstra acc1 g in
        let init = maj_distance init a g in
        let (_,node,_,_) = a in
        aux node g (node = dest) init
  in
  aux "" g false (initialisation_dijkstra src g);;

let rec distance tab node =
  MapDijkstra.fold
    (
      fun k (_,_,d,_) acc -> if (k = node) then d else acc
    ) tab 0;;

let path tab src dest =
  let rec aux l node acc =
    let (pred,k,w,_) = MapDijkstra.find node l in
    if (pred = src) then pred::acc
    else aux l pred (pred::acc)
  in
  aux tab dest [dest];;
