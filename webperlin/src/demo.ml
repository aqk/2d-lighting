(* This line opens the Tea.App modules into the current scope for Program access functions and types *)
open Contypes

open Tea.App
open Tea.Json
open Tea.Html
open Tea.AnimationFrame
open Tea.Cmd
open Tea.Time

(* This opens the Elm-style virtual-dom functions and types into the current scope *)
open Vdom
open D3
open Color
open Point
open Canvas
open CharMap
open Font
open FontDraw
open Constants
open Keys
open Poisson

(* Let's create a new type here to be our main message type that is passed around *)
type msg =
  | Focus
  | Key of string
  | Tick of (string * float) (* Time tick *)
  [@@bs.deriving {accessors}] (* This is a nice quality-of-life addon from Bucklescript, it will generate function names for each constructor name, optional, but nice to cut down on code, this is unused in this example but good to have regardless *)

type list_container =
  | List of fpoint list
  | Array of fpoint array

let list_iterate f = function
  | List l -> List.iter f l
  | Array l -> Array.iter f l

type model =
  { time : float
  ; pixels : int array
  ; pause : bool
  ; pn : float array
  ; sp : scatter_process
  ; dr_iters : int
  ; dr : fpoint array option
  }

let color_lookup = ListToCharMap.go [('x', rgba 0 120 0 255)]
let empty = rgba 128 128 128 0

let get_color_of ch =
  match ch color_lookup with
  | Some color -> color
  | None -> empty

(* This is optional for such a simple example, but it is good to have an `init` function to define your initial model default values, the model for Counter is just an integer *)
let init () =
  let imageData =
    Array.init (4 * canvas_x * canvas_y) (fun i -> if i mod 4 == 3 then 255 else 8)
  in
  let pn = Perlin.generateNoise (canvas_x / pn_factor) (canvas_y / pn_factor) in
  let nearness pd pt =
    let int_coord = get_cell_coords pd pt in
    let noise_at = pn.(int_coord.y / pn_factor * (canvas_x / pn_factor) + int_coord.x / pn_factor) in
    pd.mindist *. 1.0 +. (7.0 *. pd.mindist *. noise_at)
  in
  ({ time = 0.0
   ; pixels = imageData
   ; pause = false
   ; pn = pn
   ; sp = start_scatter_points
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
   ; dr = None
   ; dr_iters = 0
   }, NoCmd)

let whiteColor = rgba 0xff 0xff 0xff 255
let seaColor = rgba 0x47 0x4b 0x7e 255

let setPixel ia off (color : color) =
  begin
    ia.(off) <- color.r ;
    ia.(off + 1) <- color.g ;
    ia.(off + 2) <- color.b ;
    ia.(off + 3) <- color.a
  end

let lowResAvg splist n ia =
  let converged = Array.init ((canvas_x / n) * (canvas_y / n)) (fun _ -> 0) in
  let _ = list_iterate
    (fun (p : fpoint) ->
      let ipt = { x = int_of_float p.x / n ; y = int_of_float p.y / n } in
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

let dot_of (p : fpoint) =
  { x = int_of_float p.x ; y = int_of_float p.y }

let drawGame model (ia : int array) =
  begin
    let splist =
      match model.dr with
      | Some dr -> Array dr
      | None -> List (get_scatter_points model.sp)
    in
    let converged_scale = 4 in
    let converged = lowResAvg splist converged_scale ia in
    for i = 0 to canvas_y - 1 do
      let off_i = canvas_x * 4 * i in
      for j = 0 to canvas_x - 1 do
        let off = off_i + (4 * j) in
        setPixel ia off {seaColor with r = int_of_float (255.0 *. model.pn.(i / pn_factor * canvas_x / pn_factor + j / pn_factor)) ; g = converged.(i / converged_scale * canvas_x / converged_scale + j / converged_scale)}
      done
    done ;
    begin
      splist
      |> list_iterate
        (fun (p : fpoint) ->
           let ipt = dot_of p in
           let off = (ipt.y * canvas_x + ipt.x) * 4 in
           setPixel ia off whiteColor
        )
    end ;
    if model.pause then
      drawText whiteColor 1 1 0 "pause" ia
    else
      drawText whiteColor 1 1 0 "run" ia
  end

(* This is the central message handler, it takes the model as the first argument *)
let update model = function (* These should be simple enough to be self-explanatory, mutate the model based on the message, easy to read and follow *)
  | Focus ->
    begin
      setFocus "demo-input" ;
      (model, NoCmd)
    end
  | Key "Space" ->
    begin
      Js.log "space" ;
      ({ model with pause = not model.pause }, NoCmd)
    end
  | Key k ->
    begin
      Js.log k;
      (model, NoCmd)
    end
  | Tick (_,t) ->
    let _ = Js.log "tick" in
    let c2d = Js.Nullable.toOption (get_context_2d "demo-canvas") in
    match c2d with
    | None -> (model, NoCmd)
    | Some c2d ->
      begin
        let (draw_roads, updated_sp) =
          match model.dr with
          | Some dr -> (Some dr, model.sp)
          | None ->
            match scatter_point model.sp with
            | None -> (Some (Array.of_list (get_scatter_points model.sp)), model.sp)
            | Some sp -> (None, sp)
        in
        let imageData = createImageData c2d canvas_x canvas_y in
        let ia = imageDataArray imageData in
        let new_roads =
          if model.pause then
            draw_roads
          else if model.dr_iters < 5000 then
            optionMap (moveTowardRoads canvas_x canvas_y) draw_roads
          else
            model.dr
        in
        let dr_iters =
          match new_roads with
          | None -> model.dr_iters
          | Some _ -> model.dr_iters + 1
        in
        setImageSmoothingEnabled c2d false ;
        drawGame model ia ;
        putImageData c2d imageData 0 0 ;
        ({ model with time = t +. model.time ; sp = updated_sp ; dr = new_roads ; dr_iters = dr_iters }, NoCmd)
      end

let width n = attribute "" "width" (string_of_int n)
let height n = attribute "" "height" (string_of_int n)
let style settings = attribute "" "style" settings
let tabindex n = attribute "" "tabindex" (string_of_int n)
let onKeyPress key (cb : string -> 'msg) =
  onWithOptions "keypress"
    ~key:key
    {
      stopPropagation = true ;
      preventDefault = true
    } (Tea_json.Decoder.map cb (Tea_json.Decoder.at ["code"] Tea_json.Decoder.string))

(* This is the main callback to generate the virtual-dom.
  This returns a virtual-dom node that becomes the view, only changes from call-to-call are set on the real DOM for efficiency, this is also only called once per frame even with many messages sent in within that frame, otherwise does nothing *)
let view model =
  div
    [ style "background: #333; position: relative; left: 0; top: 0; width: 100%; height: 100%;"
    ; onFocus Focus
    ; tabindex 0
    ]
    [ input'
        [ id "demo-input"
        ; onKeyPress "key" (fun code -> Key code)
        ; style "width: 0; height: 0;"
        ] []
    ; canvas
        [ id "demo-canvas"
        ; width canvas_x
        ; height canvas_y
        ; style "position: relative; width: 100vh; height: 100vh;"
        ] []
    ]

let subscriptions _ = diffs (fun ~key:key t -> Tick (key,t))

(* This is the main function, it can be named anything you want but `main` is traditional.
  The Program returned here has a set of callbacks that can easily be called from
  Bucklescript or from javascript for running this main attached to an element,
  or even to pass a message into the event loop.  You can even expose the
  constructors to the messages to javascript via the above [@@bs.deriving {accessors}]
  attribute on the `msg` type or manually, that way even javascript can use it safely. *)
let main =
  standardProgram { (* The beginnerProgram just takes a set model state and the update and view functions *)
    init = init ; (* Since model is a set value here, we call our init function to generate that value *)
    update;
    view;
    subscriptions
  }
