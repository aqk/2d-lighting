
; Player missiles

(def SPEED 10) ; pixels per frame
(def player_missiles [])

(defn create-missile "Create new player missile on-screen"
      [pos target_pos]
      (set! all_missiles (conj all_missiles {:pos pos :target_pos target_pos :speed SPEED}))
      player_missiles
)

; Note: we may have to destroy other types of enemies in future
(def destroy-missiles "Destroy on-screen missiles within given circle"
     [pos radius]
     
)

(def move-player-missiles []
     (set! player_missiles (for [missile player_missiles]
           {:pos (move-along-line (get missile :pos) (get missile :target_pos) SPEED)
            :target_pos (get missile :target_pos)} ))
     player_missiles
)