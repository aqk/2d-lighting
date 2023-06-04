
(defn init-game-state []
      {:enemy_missiles ()
       :player_missiles ()
       :score 0
       :cities (init-cities)
       :silos (all_silos)
      }
)

; TODO: Choose enemy missile frequency and spawn points

; returns a new game-stae
(defn step-game-state [mouse-state old-game-state]
      ; create new objects
      ; if mouse-clicked, try to create a player_missile
      (def new_player_missiles
           (if (get mouse-state :left_click)
               (player_missiles/create-missile (get mouse-state :pos))
               (get old-game-state :enemy_missiles)
           )
      )

      ; move all objects
      (set! new_player_missiles (move-player-missiles))
      (def new_enemy_missiles (move-enemy-missiles))

      ; do collisions
      (collide-enemy-missiles cities)
      (collide-enemy-missiles silos)
      (collide-player-explosions (get new-game-state :enemy_missiles))

      ; TODO: let collisions affect silos, cities
      ; TODO: let exploding player missles affect enemy missiles
      (def new_cities (get old-game-state :cities))
      (def new_silos (get old-game-state :silos))

      ; update score
      (def new_score score)      

      {:enemy_missiles new_enemy_missiles
       :player_missiles new_player_missiles
       :score new_score
       :cities new_cities
       :silos new_silos
      }

)