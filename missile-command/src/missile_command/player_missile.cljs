
; Player missiles

(def SPEED 10) ; pixels per frame
(def player_missiles [])

(defn create-missile "Create new player missile on-screen"
      [pos target_pos]
      (set! all_missiles (conj all_missiles {:pos [] :target_pos [] :speed SPEED}))
      ; todo: return missile?
)

; Note: we may have to destroy other types of enemies in future
(def destroy-missiles "Destroy on-screen missiles within given circle"
     [pos radius]
     
)
     