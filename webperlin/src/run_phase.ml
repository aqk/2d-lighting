open Contypes
open Color
open Point
open Poisson
open Constants

type islands =
  { remaining_points: ipoint list
  ; islands: ipoint list list
  }

type run_phase =
  | Accumulate of (float array * scatter_process)
  | Distribute of (int * float array * fpoint array)
  | Connect of (float array * islands)

let dot_of (p : fpoint) =
  { x = int_of_float p.x ; y = int_of_float p.y }

let map_set (f : ipoint -> ipoint) (ips : IPointSet.t) : IPointSet.t =
  IPointSet.fold
    (fun e s -> IPointSet.union s (IPointSet.singleton (f e)))
    ips
    IPointSet.empty

let capture_set pset =
  let neighbors = [(-1,0);(1,0);(0,1);(0,-1);(-1,-1);(-1,1);(1,-1);(1,1)] in
  List.fold_left
    (fun s (x,y) ->
       IPointSet.union s (map_set (fun v -> {x = v.x + x; y = v.y + y}) s)
    )
    pset
    neighbors

(* Given a point from points (ipoint array), collect all points that are adjacent
   to point.
 *)
let make_island points =
  match points with
  | [] -> None
  | pt :: _ ->
    let hull =
      List.fold_left
        (fun cset pt ->
           if IPointSet.mem pt cset then
             IPointSet.union (capture_set (IPointSet.singleton pt)) cset
           else
             cset
        )
        (capture_set (IPointSet.singleton pt))
        points
    in
    Some (List.partition (fun pt -> IPointSet.mem pt hull) points)

let update_connected islands =
  match make_island islands.remaining_points with
  | Some (new_island, remaining_points) ->
    { remaining_points
    ; islands = new_island :: islands.islands
    }
  | None -> islands

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

let start_state () =
  let pn = Perlin.generateNoise (canvas_x / pn_factor) (canvas_y / pn_factor) in
  let nearness pd pt =
    let int_coord = get_cell_coords pd pt in
    let noise_at = pn.(int_coord.y / pn_factor * (canvas_x / pn_factor) + int_coord.x / pn_factor) in
    pd.mindist *. 1.0 +. (7.0 *. pd.mindist *. noise_at)
  in
  Accumulate
    ( pn
    , start_scatter_points
        {
          cells = IPointMap.empty ;
          samples = IntMap.empty ;
          width = canvas_x ;
          height = canvas_y ;
          k = 2 ;
          a = 1.0 ;
          mindist = 4.0 ;
          mindist_fun = nearness ;
          sample_idx = 0
        }
    )

let update_state st =
  match st with
  | Accumulate (pn, sp) ->
    begin
      match scatter_point sp with
      | None -> Distribute (0, pn, (Array.of_list (get_scatter_points sp)))
      | Some sp -> Accumulate (pn, sp)
    end
  | Distribute (dr_iters, pn, dr) ->
    if dr_iters < 1000 then
      let new_roads =
        dr
        |> moveTowardRoads canvas_x canvas_y
        |> moveTowardRoads canvas_x canvas_y
        |> moveTowardRoads canvas_x canvas_y
        |> moveTowardRoads canvas_x canvas_y
        |> moveTowardRoads canvas_x canvas_y
      in
      Distribute (dr_iters + 1, pn, new_roads)
    else
      Connect
        ( pn
        , { islands = []
          ; remaining_points = Array.map dot_of dr |> Array.to_list
          }
        )
  | Connect (pn, islands) ->
    Connect (pn, update_connected islands)

let show_points color splist ia =
  splist
  |> list_iterate
    (fun (ipt : ipoint) ->
       let off = (ipt.y * canvas_x + ipt.x) * 4 in
       setPixel ia off color
    )

let show_perlin_noise pn ia =
  for i = 0 to canvas_y - 1 do
    let off_i = canvas_x * 4 * i in
    for j = 0 to canvas_x - 1 do
      let off = off_i + (4 * j) in
      setPixel ia off {seaColor with r = int_of_float (255.0 *. pn.(i / pn_factor * canvas_x / pn_factor + j / pn_factor)) ; g = 0}
    done
  done

let show_model state ia =
  match state with
  | Accumulate (pn, sp) ->
    begin
      let splist = List (List.map dot_of (get_scatter_points sp)) in
      show_perlin_noise pn ia ;
      show_points whiteColor splist ia
    end
  | Distribute (_, pn, dr) ->
    begin
      show_perlin_noise pn ia ;
      show_points whiteColor (Array (Array.map dot_of dr)) ia
    end
  | Connect (pn, islands) ->
    begin
      show_perlin_noise pn ia ;
      show_points whiteColor (List islands.remaining_points) ia ;
      List.iter
        (fun island ->
           show_points
             { whiteColor with r = 5 * List.length island }
             (List island)
             ia
        )
        islands.islands
    end
