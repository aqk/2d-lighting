type context2d
type imageData

let get_context_2d : string -> context2d Js.Nullable.t = [%bs.raw {| function(name) { var canvasElt = document.getElementById(name); if (!canvasElt) { return null; } return canvasElt.getContext('2d'); } |} ]
let setFocus : string -> unit = [%bs.raw {| function(name) { var elt = document.getElementById(name); elt.focus(); } |}]
external createImageData : context2d -> int -> int -> imageData = "" [@@bs.send]
external putImageData : context2d -> imageData -> int -> int -> unit = "" [@@bs.send]
external imageDataArray : imageData -> int array = "data" [@@bs.get]
external setImageSmoothingEnabled : context2d -> bool -> unit = "imageSmoothingEnabled" [@@bs.set]
external getImageSmoothingEnabled : context2d -> bool = "imageSmoothingEnabled" [@@bs.get]
