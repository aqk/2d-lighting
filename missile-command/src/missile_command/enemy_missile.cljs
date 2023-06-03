
; Enemy missiles

(def SPEED 5) ; pixels per simulation tick
(def enemy_missiles [])

(defn create-missile "Create new Enemy missile on-screen"
      [pos target_pos]
      (set! enemy_missiles (conj enemy_missiles
            {:origin pos :pos pos :target_pos target_pos :speed SPEED})
      )
)

; Note: we may have to destroy other types of enemies in future
(def destroy-missiles "Destroy on-screen missiles within given circle"
     [pos radius]
     
)
     