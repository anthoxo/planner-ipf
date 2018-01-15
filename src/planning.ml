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

let queue_to_list q =
  MapQueue.bindings q


let print_queue q =
  let l = queue_to_list q in
  let rec aux1 l =
    match l with
      |[] -> ()
      |((n,e1,e2,p,tot)::s) ->
        let _ = print_string ("("^(string_of_int n)^","^e1^","^e2^",") in
        let _ = print_int p in
        let _ = print_string (","^(string_of_int tot)^") - ") in
        aux1 s
  in
  let rec aux2 l =
    match l with
      |[] -> ()
      |(k,li)::s ->
        let _ = print_string ((string_of_int k)^" : ") in
        let _ = aux1 li in
        let _ = print_string "\n" in
        aux2 s
  in
  aux2 l

let check g q =
  MapQueue.fold
    (
      fun k v acc ->
        let rec aux l acc1 =
          match l with
            |[] -> acc1
            |((n,e1,e2,p,total)::s) ->
              let tmp = MapQueue.fold
                (
                  fun k2 v2 acc2 ->
                    let rec check_aux k3 l3 acc3 =
                      match l3 with
                        |[] -> acc3
                        |((n1,e11,e12,p1,total1)::s) ->
                          if (p <= k2 || k >= p1 || n1 = n)
                          then
                            check_aux k3 s acc3
                          else if ((e11 = e1 && e12 = e2) || (e11 = e2 && e12 = e1))
                          then
                            (e1,e2,[n1;n])::acc3
                          else
                            check_aux k3 s acc3
                    in
                    if (k2 > k) then acc2
                    else if (acc2 = []) then check_aux k2 v2 []
                    else acc2
                ) q []
              in
              if (tmp = []) then aux s acc1
              else tmp
        in
        if (acc = []) then aux v []
        else acc
    ) q []

let find_elt n e1 e2 q =
  MapQueue.fold (
      fun k v acc ->
        let rec aux l acc1 =
          match l with
            |[] -> acc1
            |(n1,e11,e12,p,tot)::s ->
              if (n1 = n && ((e1 = e11 && e2 = e12) || (e1 = e12 && e2 = e11)))
              then
                (n1,e11,e12,p,tot)
              else
                aux s acc1
        in
        let (n2,_,_,_,_) = acc in
        if (n2 = -1)
        then
          aux v (-1,"","",0,0)
        else
          acc
    ) q (-1,"","",0,0)

let update_weight n deb weight g q =
  MapQueue.fold
    (
      fun k v acc ->
        if (k < deb) then MapQueue.add k v acc
        else
          let rec aux l acc1 =
            match l with
              |[] -> acc1
              |((i,n1,n2,f,total)::s) ->
                let p = Graph.find_edge (Graph.edge n1 n2) g in
                if (i = n)
                then
                  aux s (add i (Graph.edge n1 n2) g (f-p+weight) (total+weight) acc1)
                else
                  aux s (add i (Graph.edge n1 n2) g (f-p) total acc1)
          in
          aux v acc
    ) q empty

let total_time q =
  MapQueue.fold (
    fun k v acc ->
      let rec aux l acc1 =
        match l with
          |[] -> acc1
          |(_,_,_,_,t)::s -> aux s (max acc1 t)
      in
      aux v 0
    ) q 0

let update g q =
  let rec aux l acc =
    match l with
      |[] -> acc
      |(e1,e2,li)::s ->
        match li with
        |[] -> assert false
        |p::[] -> assert false
        |(a::(b::s)) ->
          let (n1,_,_,p1,total1) = find_elt a e1 e2 acc in
          let (n2,_,_,p2,total2) = find_elt b e1 e2 acc in
          let k1 = p1-(Graph.find_edge (Graph.edge e1 e2) g) in
          let k2 = p2-(Graph.find_edge (Graph.edge e1 e2) g) in
          let tmp1 = update_weight n2 (k1-1) (p1-k2) g acc in
          let tmp2 = update_weight n1 (k2-1) (p2+p1-2*k1) g acc in
          if ((total_time tmp1) > (total_time tmp2))
          then
            let _ = print_queue tmp2 in
            aux (check g tmp2) tmp2
          else
            let _ = print_queue tmp1 in
            aux (check g tmp1) tmp1
  in
  aux (check g q) q

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
