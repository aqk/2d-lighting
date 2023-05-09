type color =
  { r : int
  ; g : int
  ; b : int
  ; a : int
  }

let rgba r g b a = { r ; g ; b ; a }

let empty = rgba 128 128 128 0
let whiteColor = rgba 0xff 0xff 0xff 255
let seaColor = rgba 0x47 0x4b 0x7e 255

let setPixel ia off (color : color) =
  begin
    ia.(off) <- color.r ;
    ia.(off + 1) <- color.g ;
    ia.(off + 2) <- color.b ;
    ia.(off + 3) <- color.a
  end
