(ns missile-command.player_missile)

(require '[missile-command.pos :as pos])

; Player missiles

(def SPEED 200) ; pixels per second

(defn create-missile "Create new player missile on-screen"
      [pos target_pos]
  {:pos pos :target_pos target_pos :speed SPEED}
  )

;; (defn create-missile-in-module-collection "Create new player missile on-screen"
;;   (set! all_missiles (conj all_missiles {:pos pos :target_pos target_pos :speed SPEED}))
;;   player_missiles
;;   )

; Note: we may have to destroy other types of enemies in future
;; (def destroy-missiles "Destroy on-screen missiles within given circle"
;;      [pos radius]
     
;; )

(defn move-player-missiles [player-missiles time]
  (for [missile player-missiles]
    {:pos (pos/move-along-line (get missile :pos) (get missile :target_pos) SPEED time)
     :target_pos (get missile :target_pos)}
    )
  )
