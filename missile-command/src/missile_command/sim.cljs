(ns missile-command.sim)

(require '[missile-command.util :as util])
(require '[missile-command.silo :as silo])
(require '[missile-command.cities :as cities])
(require '[missile-command.player_missile :as player_missile])

(defn init-game-state []
      {:kind "game"
       :enemy_missiles ()
       :player_missiles ()
       :explosions ()
       :cities (cities/init-cities)
       :silos (silo/get-silos)
       :wave 1
       :score 0
      }
)

; TODO: Choose enemy missile frequency and spawn points

;; create new objects
;; if mouse-clicked, try to create a player_missile
(defn add_new_player_missile_if_clicked [mouse-state old-game-state]
  (if (get mouse-state :left_click)
    (let [origin {:x 0 :y 0}] ;; XXX Pick an origin
      (let [new-missile (player_missile/create-missile origin (get mouse-state :pos))]
        (let [old-missile-list (old-game-state :player_missiles)]
          (let [new-state (update-in old-game-state [:player_missiles] util/const-update (cons new-missile old-missile-list))]
            (println "new missile" new-state)
            new-state
            )
          )
        )
      )
    old-game-state
    )
  )

(defn move-player-missiles [old-game-state] old-game-state)

(defn move-enemy-missiles [old-game-state] old-game-state)

(defn collide-enemy-missiles-with-cities [old-game-state] old-game-state)

(defn collide-enemy-missiles-with-silos [old-game-state] old-game-state)

(defn collide-player-explosions [old-game-state] old-game-state)

; returns a new game-stae
(defn step-game-state [mouse-state old-game-state]
  (->> old-game-state
       ;; move all objects
       (add_new_player_missile_if_clicked mouse-state)
       (move-player-missiles)
       (move-enemy-missiles)

       ;; do collisions
       (collide-enemy-missiles-with-cities)
       (collide-enemy-missiles-with-silos)
       (collide-player-explosions)
       )
  )
