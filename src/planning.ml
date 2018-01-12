type queue = (int * Graph.edge * int * int) list;;

exception Empty;;

let empty = [];;

let is_empty q = (q = []);;

let rec add n edge priority1 priority2 q =
  match q with
    |[] -> [(n,edge,priority1,priority2)]
    |t::s ->
      let (_,_,p1,p2) = t in
      if (p1 > priority1) || (p1 = priority1 && p2 > priority2)
      then
        (n,edge,priority1,priority2)::q
      else
        t::(add n edge priority1 priority2 s);;

let peek q =
  match q with
  |empty -> raise Empty
  |t::_ -> t;;

let pop q =
  match q with
  |empty -> raise Empty
  |_::s -> s;;

let fill n path q g =
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
          aux n s t priority (add n (Graph.edge t node) acc priority q) g
  in
  match path with
    |[] -> raise Empty
    |t::s -> aux n s t 0 q g;;

let fill_all li q g =
  let rec aux li acc q g =
    match li with
      |[] -> (q,acc)
      |t::s -> aux s (acc+1) (fill acc t q g) g
  in
  aux li 0 q g;;

let rec queue_to_list q =
  match q with
  |[] -> []
  |t::s -> t::(queue_to_list s);;

let rec update_weight n weight q =
  match q with
    [] -> []
    |(i,edge,p1,p2)::s ->
      if (i = n)
      then
        (i,edge,p1+weight,p2+weight)::(update_weight n weight s)
      else
        (i,edge,p1,p2)::(update_weight n weight s);;

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
