open Contypes
open Color
open Point
open Poisson
open Constants

type run_phase =
  | Accumulate of (float array * scatter_process)
  | Distribute of (int * fpoint array)
  | Connect of (ipoint array)

let dot_of (p : fpoint) =
  { x = int_of_float p.x ; y = int_of_float p.y }

let map_set (f : ipoint -> ipoint) (ips : IPointSet.t) : IPointSet.t =
  IPointSet.fold
    (fun e s -> IPointSet.union s (IPointSet.singleton (f e)))
    ips
    IPointSet.empty

let capture_set pset =
  let neighbors = [(-1,0);(1,0);(0,1);(0,-1)] in
  List.fold_left
    (fun s (x,y) ->
       IPointSet.union s (map_set (fun v -> {x = v.x + x; y = v.y + y}) s)
    )
    pset
    neighbors

let isolate_island c road_array =
  let pset = capture_set (IPointSet.singleton (Array.get road_array c)) in
  let rec isolate_inner pset remaining =
    let (found_points, remaining_points) =
      List.partition
        (fun v -> IPointSet.mem v pset)
        remaining
    in
    match found_points with
    | [] -> (pset, remaining_points)
    | _ ->
      let new_point_capture_set =
        List.fold_left
          (fun s v -> IPointSet.union s (capture_set (IPointSet.singleton v)))
          pset
          found_points
      in
      isolate_inner new_point_capture_set remaining_points
  in
  isolate_inner pset (Array.to_list road_array)

let rec make_islands islands road_array =
  let rlen = Array.length road_array in
  if rlen == 0 then
    islands
  else
    let c = 0 in
    let (new_island, remaining_roads) = isolate_island c road_array in
    make_islands ((IPointSet.elements new_island) :: islands) (Array.of_list remaining_roads)

let lowResAvg splist n ia =
  let converged = Array.init ((canvas_x / n) * (canvas_y / n)) (fun _ -> 0) in
  let _ = list_iterate
    (fun (p : ipoint) ->
      let ipt = { x = p.x / n ; y = p.y / n } in
      let off = ipt.y * canvas_x / n + ipt.x in
      converged.(off) <- converged.(off) + 15
    )
    splist
  in
  converged

let cluster_of (p : fpoint) =
  { x = (int_of_float p.x) / cluster_sz ; y = (int_of_float p.y) / cluster_sz }

let make_clustered array =
  Array.fold_left
    (fun res p ->
       let target : ipoint = cluster_of p in
       IPointUpdate.go target
         (function
           | None -> Some [p]
           | Some pl -> Some (p :: pl)
         )
         res
    )
    IPointMap.empty
    array

let dist (p1 : fpoint) (p2 : fpoint) =
  let dx = p1.x -. p2.x in
  let dy = p1.y -. p2.y in
  sqrt ((sqr dx) +. (sqr dy))

let sort_by_dist_to array mid =
  let _ =
    Array.sort
      (fun a b ->
         let da = dist a mid in
         let db = dist b mid in
         Pervasives.compare da db
      )
      array
  in
  array

let close_in_midpoint road_array len =
  if len == 0 then
    [| |]
  else
    let choice1 : fpoint = Array.get road_array (choice len) in
    let choice2 : fpoint = Array.get road_array (choice len) in
    let mid : fpoint = { x = (choice1.x +. choice2.x) /. 2.0 ; y = (choice1.y +. choice2.y) /. 2.0 } in
    let sorted_by_distance = sort_by_dist_to road_array mid in
    let _ = Array.set road_array 0 mid in
    road_array

(*
 *
 *  +-----+-----+-----+
 *  |   x | .   |     |
 *  |x    |   . |  x  |
 *  +-----+-----+-----+
 *
 *)
let moveTowardRoads width height road_array =
  let len = Array.length road_array in
  let locus = Array.get road_array (choice len) in
  let sorted = sort_by_dist_to road_array locus in
  close_in_midpoint sorted (min 7 len)

let update_state = function
  | Accumulate (pn, sp) ->
    begin
      match scatter_point sp with
      | None -> Distribute (0, (Array.of_list (get_scatter_points sp)))
      | Some sp -> Accumulate (pn, sp)
    end
  | Distribute (dr_iters, dr) ->
    if dr_iters < 5000 then
      Distribute (dr_iters + 1, moveTowardRoads canvas_x canvas_y dr)
    else
      Connect (Array.map dot_of dr)
  | Connect x -> Connect x

let show_points splist ia =
  splist
  |> list_iterate
    (fun (ipt : ipoint) ->
       let off = (ipt.y * canvas_x + ipt.x) * 4 in
       setPixel ia off whiteColor
    )

let show_model state ia =
  match state with
  | Accumulate (pn, sp) ->
    begin
      let converged_scale = 4 in
      let splist = List (List.map dot_of (get_scatter_points sp)) in
      let converged = lowResAvg splist converged_scale ia in
      for i = 0 to canvas_y - 1 do
        let off_i = canvas_x * 4 * i in
        for j = 0 to canvas_x - 1 do
          let off = off_i + (4 * j) in
          setPixel ia off {seaColor with r = int_of_float (255.0 *. pn.(i / pn_factor * canvas_x / pn_factor + j / pn_factor)) ; g = converged.(i / converged_scale * canvas_x / converged_scale + j / converged_scale)}
        done
      done ;
      show_points splist ia
    end
  | Distribute (_, dr) -> show_points (Array (Array.map dot_of dr)) ia
  | Connect ipa -> show_points (Array ipa) ia
