open CharMap
open Color
open Font
open Constants

let rec drawText color x y n str ia =
  if n >= String.length str then
    ()
  else
    begin
      let theChar =
        try
          CharMap.find (Char.uppercase str.[n]) theFont
        with _ ->
          CharMap.find '\000' theFont
      in
      let charHeight = (String.length theChar.def) / theChar.width in
      let max_y = y + charHeight in
      let max_x = x + theChar.width in
      if max_y > canvas_y then
        ()
      else if max_x >= canvas_x then
        drawText color 0 (y + charHeight) n str ia
      else
        begin
          for i = 0 to charHeight - 1 do
            let off_row = (i + y) * 4 * canvas_x in
            for j = 0 to theChar.width - 1 do
              let off = off_row + 4 * (j + x) in
              if theChar.def.[i * theChar.width + j] != ' ' then
                begin
                  ia.(off) <- color.r ;
                  ia.(off + 1) <- color.g ;
                  ia.(off + 2) <- color.b ;
                  ia.(off + 3) <- color.a
                end
            done
          done ;
          drawText color (x + theChar.width) y (n + 1) str ia
        end
    end

