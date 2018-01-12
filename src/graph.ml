(* ce module représente un ensemble d'arêtes étiquetées *)
module MapNode = Map.Make(String)
module MapGraph = Map.Make(String)

type node = int MapNode.t

type edge = string * string

type graph = node MapGraph.t

let edge src dest = (src,dest)

let edge_split (a,b) = (a,b)

let empty = MapGraph.empty

let is_empty g = MapGraph.is_empty g

let cardinal g = MapGraph.cardinal g

let mem_node n g =
  MapGraph.mem n g

let add_edge (n1,n2) weight g =
  let aux1 n g =
    if not (mem_node n g)
    then
      MapGraph.add n (MapNode.empty) g
    else
      g
  in
  let g = aux1 n1 g in
  let g = aux1 n2 g in
  let aux2 n a g =
    let nn = MapGraph.find n g in
    let nn = MapNode.add a weight nn in
    MapGraph.add n nn g
  in
  let g = aux2 n1 n2 g in
  let g = aux2 n2 n1 g in
  g

let rec add_edge_list li g =
  match li with
    |[] -> g
    |(a,b,weight)::s ->
      add_edge (a,b) weight (add_edge_list s g)

let find_edge (n1,n2) g =
  let a = MapGraph.fold
    (fun k v acc -> if (n1 = k) then v::acc else acc) g []
  in
  match a with
    |[] -> -1
    |(p::q) ->
      try
        (MapNode.find n2 p)
      with
      | Not_found -> -1

let fold f g acc = MapGraph.fold f g acc

let distance_path li g =
  let rec aux l pred g acc =
    match li with
      |[] -> acc
      |p::q ->
        let w = find_edge (edge p pred) g in
        if w = -1 then failwith "Arête non trouvé"
        else aux q p g acc+w
  in
  match li with
    |[] -> 0
    |p::q -> aux q p g 0
