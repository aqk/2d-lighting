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
open Run_phase

(* Let's create a new type here to be our main message type that is passed around *)
type msg =
  | Focus
  | Key of string
  | Tick of (string * float) (* Time tick *)
  [@@bs.deriving {accessors}] (* This is a nice quality-of-life addon from Bucklescript, it will generate function names for each constructor name, optional, but nice to cut down on code, this is unused in this example but good to have regardless *)

type model =
  { time : float
  ; pause : bool
  ; state : run_phase
  }

let color_lookup = ListToCharMap.go [('x', rgba 0 120 0 255)]

let get_color_of ch =
  match ch color_lookup with
  | Some color -> color
  | None -> empty

(* This is optional for such a simple example, but it is good to have an `init` function to define your initial model default values, the model for Counter is just an integer *)
let init () =
  let imageData =
    Array.init (4 * canvas_x * canvas_y) (fun i -> if i mod 4 == 3 then 255 else 8)
  in
  ({ time = 0.0
   ; pause = false
   ; state = start_state ()
   }, NoCmd)

let drawGame model (ia : int array) =
  begin
    let _ = show_model model.state ia in
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
        let imageData = createImageData c2d canvas_x canvas_y in
        let ia = imageDataArray imageData in
        let _ = setImageSmoothingEnabled c2d false in
        let new_model =
          { model with
            time = t +. model.time
          ; state = update_state model.state
          }
        in
        let _ = drawGame new_model ia in
        let _ = putImageData c2d imageData 0 0 in
        (new_model, NoCmd)
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
