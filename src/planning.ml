module MapQueue = Map.Make(struct type t = int let compare = compare end);;
type queue = (int * string * string * int * int) list MapQueue.t

exception Empty

let empty = MapQueue.empty

let is_empty q = MapQueue.is_empty q

let add n edge g p total q =
  let weight = Graph.find_edge edge g in
  if (weight = -1)
  then
    q
  else
    let (a,b) = Graph.edge_split edge in
    let tmp =
      try
        MapQueue.find p q
      with
      | Not_found -> []
    in
    MapQueue.add p ((n,a,b,p+weight,total)::tmp) q

let fill n path total g q =
  let rec aux n path node acc g q =
    match path with
      |[] -> q
      |t::s ->
        let weight = Graph.find_edge (Graph.edge t node) g in
        if weight = -1
        then
          assert false
        else
          let priority = acc + weight in
          aux n s t priority g (add n (Graph.edge t node) g acc total q)
  in
  match path with
    |[] -> raise Empty
    |t::s -> aux n s t 0 g q

let fill_all li g q =
  let rec aux li acc g q =
    match li with
      |[] -> (q,acc)
      |t::s ->
        let total = Graph.distance_path t g in
        aux s (acc+1) g (fill acc t total g q)
  in
  aux li 0 g q

let rec queue_to_list q =
  MapQueue.bindings q

let update_weight n deb weight g q =
  MapQueue.fold
    (
      fun k v acc ->
        if (k < deb) then MapQueue.add k v acc
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
          if (indice = -1) then MapQueue.add k a1 acc
          else
            if (a1 = [])
            then
              add n (Graph.edge e1 e2) g (k+weight) (total+weight) acc
            else
              let tmp2 = MapQueue.add k a1 acc in
              add n (Graph.edge e1 e2) g (k+weight) (total+weight) tmp2
    ) q empty

let update g q =
  let check elt q =
    let (n,e1,e2,p,total) = elt in
    let k1 = p-(Graph.find_edge (Graph.edge e1 e2) g) in
    MapQueue.fold
      (
        fun k v acc ->
          let rec aux l acc1 =
            match l with
              |[] -> acc1
              |((n1,e11,e12,p1,total1)::s) ->
                if (k1 >= p1) then aux s acc1
                else if ((e1=e11 && e2=e12) || (e1=e12 && e2=e11))
                then
                  p1-k1
                else aux s acc1
          in
          if (p <= k) then acc
          else max (aux v 0) acc
      ) q 0
  in
  MapQueue.fold
    (
      fun k v acc ->
        let rec aux l acc1 q1 =
          match l with
            |[] -> acc1
            |((n,e1,e2,p,total)::s) ->
              let weight = check (n,e1,e2,p,total) acc1 in
              if (weight = 0)
              then
                aux s (add n (Graph.edge e1 e2) g k total acc1) q1
              else
                let q2 = update_weight n k weight g q1 in
                aux s (add n (Graph.edge e1 e2) g (k+weight) (total+weight) acc1) q2
        in
        aux v acc q
    ) q MapQueue.empty

let split_queue q nb =
  let rec aux1 i =
    match i with
      |0 -> []
      |i -> []::(aux1 (i-1))
  in
  let rec aux2 li elt i =
    match (i,li) with
      |0,(t::s) -> let tmp = elt::t in tmp::s
      |i,[] -> raise Empty
      |i,(t::s) -> t::(aux2 s elt (i-1))
  in
  MapQueue.fold
    (
      fun k v acc ->
        let rec aux l acc1 =
          match l with
            |[] -> acc1
            |((n,e1,e2,p,total)::s) ->
              aux s (aux2 acc1 (n,e1,e2,p,total) n)
        in
        aux v acc
    ) q (aux1 nb)
