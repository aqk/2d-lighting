open Contypes
open Point

let neighbors_dxdy = [
  (-1,-2) ;
  (0,-2) ;
  (1,-2) ;
  (-2,-1) ;
  (-1,-1) ;
  (0,-1) ;
  (1,-1) ;
  (2,-1) ;
  (-2,0) ;
  (-1,0) ;
  (1,0) ;
  (2,0) ;
  (-2,1) ;
  (-1,1) ;
  (0,1) ;
  (1,1) ;
  (2,1) ;
  (-1,2) ;
  (0,2) ;
  (1,2) ;
  (0,0)
]

type poisson_disc = {
  width: int ;
  height: int ;
  cells: int IPointMap.t ;
  k : int ; (* Maximum iterations *)
  a : float ; (* Partition size within the field *)
  mindist : float ;
  mindist_fun : poisson_disc -> fpoint -> float ;
  sample_idx : int ;
  samples : fpoint IntMap.t
}

let get_neighbors (pd : poisson_disc) (p : ipoint) : int list =
  List.fold_left
    (fun res (dx,dy) ->
       let neighbor : ipoint = { x = p.x + dx ; y = p.y + dy } in
       if neighbor.x < 0 || neighbor.x >= pd.width || neighbor.y < 0 || neighbor.y >= pd.height then
         res
       else
         match IPointFind.go neighbor pd.cells with
         | Some c -> c :: res
         | _ -> res
    )
    []
    neighbors_dxdy

let get_cell_coords (pd : poisson_disc) (p : fpoint) : ipoint =
  { x = int_of_float (p.x /. pd.a) ; y = int_of_float (p.y /. pd.a) }

let sqr (x : float) = x *. x

let point_valid (pd : poisson_disc) (p : fpoint) : bool =
  let cell_coords = get_cell_coords pd p in
  let mindist_at = pd.mindist_fun pd p in
  let neighbors = get_neighbors pd cell_coords in
  List.fold_left
    (fun res idx ->
       if res then
         match IntFind.go idx pd.samples with
         | None -> res
         | Some nearby_pt ->
           let distance2 = sqr (nearby_pt.x -. p.x) +. sqr (nearby_pt.y -. p.y) in
           if distance2 < mindist_at then
             false
           else
             res
       else
         false
    )
    true
    neighbors

let get_point (pd : poisson_disc) (p : fpoint) : fpoint option =
  let result = ref None in
  let i = ref 0 in
  let maybe_set_result (pt : fpoint) =
    if (not (pt.x < 0.0 || pt.x >= (float_of_int pd.width) || pt.y < 0.0 || pt.y >= (float_of_int pd.height))) && point_valid pd pt then
      result := Some pt
    else
      i := (!i) + 1
  in
  while (!result) = None && (!i) < pd.k do
    let random_rho = pd.mindist +. ((random ()) *. 3.0 *. pd.mindist) in
    let rho = sqrt random_rho in
    let theta = random () *. 2.0 *. pi in
    let pt: fpoint = {x = p.x +. rho *. cos theta ; y = p.y +. rho *. sin theta} in
    maybe_set_result pt
  done ;
  !result

let add_sample (pd : poisson_disc) (pt : fpoint) =
  let next_sample_id = pd.sample_idx in
  let cell_pos = get_cell_coords pd pt in
  { pd with
    sample_idx = pd.sample_idx + 1 ;
    samples = IntUpdate.go next_sample_id (fun _ -> Some pt) pd.samples ;
    cells = IPointUpdate.go cell_pos (fun _ -> Some next_sample_id) pd.cells
  }

type scatter_process = {
  pd : poisson_disc ;
  active : fpoint list
}

let start_scatter_points (pd : poisson_disc) : scatter_process =
  let first_pt: fpoint = {x = random () *. (float_of_int pd.width); y = random () *. (float_of_int pd.height)} in
  let new_pd = add_sample pd first_pt in
  { pd = new_pd ; active = [first_pt] }

let scatter_active (sp : scatter_process) : bool =
  match sp.active with
  | [] -> false
  | _ -> true

let scatter_point (sp : scatter_process) : scatter_process option =
  if not (scatter_active sp) then
    None
  else
    let active_idx = choice (List.length sp.active) in
    let refpt = List.nth sp.active active_idx in
    match get_point sp.pd refpt with
    | None -> Some { sp with active = List.filter (fun a -> a != refpt) sp.active }
    | Some pt ->
      Some { sp with pd = add_sample sp.pd pt ; active = pt :: sp.active }

let get_scatter_points (sp : scatter_process) : fpoint list =
  sp.pd.cells
  |> IPointMap.bindings
  |> List.map
    (fun (_,v) ->
       match IntFind.go v sp.pd.samples with
       | None -> []
       | Some pt -> [pt]
    )
  |> List.concat
