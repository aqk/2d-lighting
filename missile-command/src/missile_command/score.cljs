
; Thanks to https://www.retrogamedeconstructionzone.com/2019/11/missilie-command-deep-dive.html

(def MISSILE_SCORE        25)
(def SMART_BOMB_SCORE    125)
(def BOMBER_PLANE_SCORE  100)
(def SATELLITE_SCORE     100)
(def CITY_SURVIVED_LEVEL 100)
(def UNUSED_ABM            5)

(defn score-multiplier [level] (cond
      (< level 3)  1
      (< level 5)  2
      (< level 7)  3
      (< level 9)  4
      (< level 11) 5
      :else 6
))


(defn level_bonus_score [level abms cities_ok]
      let [mult (score-multiplier level)]
      (* mult (+ (* abms UNUSED_ABM) (* cities_ok CITY_SURVIVED_LEVEL)))
)