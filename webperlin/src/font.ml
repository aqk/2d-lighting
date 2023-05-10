open CharMap

type glyph = { width : int ; def : string }

let theFont =
  ListToCharMap.go
    [ ( '0'
      , { width = 4
        ; def =
            " 0  " ^
            "0 0 " ^
            "0 0 " ^
            "0 0 " ^
            " 0  " ^
            "    "
        }
      )
    ; ( '1'
      , { width = 4
        ; def =
            " 1  " ^
            "11  " ^
            " 1  " ^
            " 1  " ^
            "111 " ^
            "    "
        }
      )
    ; ( '2'
      , { width = 4
        ; def =
            "22  " ^
            "  2 " ^
            " 2  " ^
            "2   " ^
            "222 " ^
            "    "
        }
      )
    ; ( '3'
      , { width = 4
        ; def =
            "33  " ^
            "  3 " ^
            " 3  " ^
            "  3 " ^
            "33  " ^
            "    "
        }
      )
    ; ( '4'
      , { width = 4
        ; def =
            "  4 " ^
            "4 4 " ^
            "444 " ^
            "  4 " ^
            "  4 " ^
            "    "
        }
      )
    ; ( '5'
      , { width = 4
        ; def =
            "555 " ^
            "5   " ^
            "55  " ^
            "  5 " ^
            "55  " ^
            "    "
        }
      )
    ; ( '6'
      , { width = 4
        ; def =
            " 66 " ^
            "6   " ^
            "66  " ^
            "6 6 " ^
            " 6  " ^
            "    "
        }
      )
    ; ( '7'
      , { width = 4
        ; def =
            "777 " ^
            "  7 " ^
            " 7  " ^
            " 7  " ^
            " 7  " ^
            "    "
        }
      )
    ; ( '8'
      , { width = 4
        ; def =
            " 8  " ^
            "8 8 " ^
            " 8  " ^
            "8 8 " ^
            " 8  " ^
            "    "
        }
      )
    ; ( '9'
      , { width = 4
        ; def =
            " 9  " ^
            "9 9 " ^
            " 99 " ^
            "  9 " ^
            " 9  " ^
            "    "
        }
      )
    ; ( 'A'
      , { width = 4
        ; def =
            " A  " ^
            "A A " ^
            "AAA " ^
            "A A " ^
            "A A " ^
            "    "
        }
      )
    ; ( 'B'
      , { width = 4
        ; def =
            "BB  " ^
            "B B " ^
            "BB  " ^
            "B B " ^
            "BB  " ^
            "    "
        }
      )
    ; ( 'C'
      , { width = 4
        ; def =
            " C  " ^
            "C C " ^
            "C   " ^
            "C C " ^
            " C  " ^
            "    "
        }
      )
    ; ( 'D'
      , { width = 4
        ; def =
            "DD  " ^
            "D D " ^
            "D D " ^
            "D D " ^
            "DD  " ^
            "    "
        }
      )
    ; ( 'E'
      , { width = 4
        ; def =
            "EEE " ^
            "E   " ^
            "EE  " ^
            "E   " ^
            "EEE " ^
            "    "
        }
      )
    ; ( 'F'
      , { width = 4
        ; def =
            "FFF " ^
            "F   " ^
            "FF  " ^
            "F   " ^
            "F   " ^
            "    "
        }
      )
    ; ( 'G'
      , { width = 4
        ; def =
            " G  " ^
            "G G " ^
            "G   " ^
            "GGG " ^
            " GG " ^
            "    "
        }
      )
    ; ( 'H'
      , { width = 4
        ; def =
            "H H " ^
            "H H " ^
            "HHH " ^
            "H H " ^
            "H H " ^
            "    "
        }
      )
    ; ( 'I'
      , { width = 4
        ; def =
            "III " ^
            " I  " ^
            " I  " ^
            " I  " ^
            "III " ^
            "    "
        }
      )
    ; ( 'J'
      , { width = 4
        ; def =
            " JJ " ^
            "  J " ^
            "  J " ^
            "J J " ^
            " J  " ^
            "    "
        }
      )
    ; ( 'K'
      , { width = 4
        ; def =
            "K K " ^
            "K K " ^
            "KK  " ^
            "K K " ^
            "K K " ^
            "    "
        }
      )
    ; ( 'L'
      , { width = 4
        ; def =
            "L   " ^
            "L   " ^
            "L   " ^
            "L   " ^
            "LLL " ^
            "    "
        }
      )
    ; ( 'M'
      , { width = 6
        ; def =
            "M   M " ^
            "MM MM " ^
            "M M M " ^
            "M   M " ^
            "M   M " ^
            "      "
        }
      )
    ; ( 'N'
      , { width = 5
        ; def =
            "N  N " ^
            "NN N " ^
            "N NN " ^
            "N  N " ^
            "N  N " ^
            "     "
        }
      )
    ; ( 'O'
      , { width = 4
        ; def =
            " O  " ^
            "O O " ^
            "O O " ^
            "O O " ^
            " O  " ^
            "    "
        }
      )
    ; ( 'P'
      , { width = 4
        ; def =
            "PP  " ^
            "P P " ^
            "PP  " ^
            "P   " ^
            "P   " ^
            "    "
        }
      )
    ; ( 'Q'
      , { width = 4
        ; def =
            " Q  " ^
            "Q Q " ^
            "Q Q " ^
            "Q Q " ^
            " QQ " ^
            "    "
        }
      )
    ; ( 'R'
      , { width = 4
        ; def =
            "RR  " ^
            "R R " ^
            "RR  " ^
            "R R " ^
            "R R " ^
            "    "
        }
      )
    ; ( 'S'
      , { width = 4
        ; def =
            " SS " ^
            "S   " ^
            " S  " ^
            "  S " ^
            "SS  " ^
            "    "
        }
      )
    ; ( 'T'
      , { width = 4
        ; def =
            "TTT " ^
            " T  " ^
            " T  " ^
            " T  " ^
            " T  " ^
            "    "
        }
      )
    ; ( 'U'
      , { width = 4
        ; def =
            "U U " ^
            "U U " ^
            "U U " ^
            "U U " ^
            " UU " ^
            "    "
        }
      )
    ; ( 'V'
      , { width = 4
        ; def =
            "V V " ^
            "V V " ^
            "V V " ^
            "VVV " ^
            " V  " ^
            "    "
        }
      )
    ; ( 'W'
      , { width = 6
        ; def =
            "W W W " ^
            "W W W " ^
            "W W W " ^
            "W W W " ^
            " W W  " ^
            "      "
        }
      )
    ; ( 'X'
      , { width = 4
        ; def =
            "X X " ^
            "X X " ^
            " X  " ^
            "X X " ^
            "X X " ^
            "    "
        }
      )
    ; ( 'Y'
      , { width = 4
        ; def =
            "Y Y " ^
            "Y Y " ^
            " Y  " ^
            " Y  " ^
            " Y  " ^
            "    "
        }
      )
    ; ( 'Z'
      , { width = 4
        ; def =
            "ZZZ " ^
            "  Z " ^
            " Z  " ^
            "Z   " ^
            "ZZZ " ^
            "    "
        }
      )
    ; ( '-'
      , { width = 4
        ; def =
            "    " ^
            "    " ^
            "--- " ^
            "    " ^
            "    " ^
            "    "
        }
      )
    ; ( '+'
      , { width = 4
        ; def =
            "    " ^
            " +  " ^
            "+++ " ^
            " +  " ^
            "    " ^
            "    "
        }
      )
    ; ( '.'
      , { width = 4
        ; def =
            "    " ^
            "    " ^
            "    " ^
            " .. " ^
            " .. " ^
            "    "
        }
      )
    ; ( '\000'
      , { width = 4
        ; def =
            " x  " ^
            "xxx " ^
            "xxx " ^
            " x  " ^
            "    " ^
            "    "
        }
      )
    ]
