(ns missile-command.player_missile)

; Player missiles

(def SPEED 10) ; pixels per frame

(defn create-missile "Create new player missile on-screen"
      [pos target_pos]
  {:pos pos :target_pos target_pos :speed SPEED}
  )

; Note: we may have to destroy other types of enemies in future
;; (def destroy-missiles "Destroy on-screen missiles within given circle"
;;      [pos radius]
;; )
