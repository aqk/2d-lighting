let rec fold_left f s l =
  match l with
  | hd :: tl -> fold_left f (f s hd) tl
  | _ -> s

module type Ord = sig
  type t
  val compare : t -> t -> int
end

module ListToMap(OrdType : Ord) = struct
  module MapT = Map.Make(OrdType)
  let go (l : (OrdType.t * 'a) list) : 'a MapT.t =
    fold_left
      (fun m (k,v) -> MapT.add k v m)
      MapT.empty
      l
end

module FindMap (O : Ord) = struct
  module MapT = Map.Make(O)
  let go (key : MapT.key) (map : 'a MapT.t) : 'a option =
    try
      Some (MapT.find key map)
    with _ -> None
end

module UpdateMap (O : Ord) = struct
  module MapT = Map.Make(O)
  module Find = FindMap(O)
  let go (key : MapT.key) (f : 'a option -> 'a option) (map : 'a MapT.t) =
    let res = Find.go key map in
    match f res with
    | Some a -> MapT.remove key map |> MapT.add key a
    | None -> MapT.remove key map
end

module IntOrd = struct
  type t = int
  let compare = Pervasives.compare
end

module IntMap = Map.Make(IntOrd)
module IntFind = FindMap(IntOrd)
module IntUpdate = UpdateMap(IntOrd)

let random : unit -> float = [%bs.raw {| function(x) { return Math.random(); } |} ]
let pi = 3.141592653
let choice : int -> int = [%bs.raw {| function(choices) { return Math.floor(Math.random() * choices); } |} ]
