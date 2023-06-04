
; Player missile explosions

(def INITIAL_RADIUS 5)
(def GROWTH_RATE 5) ; pixels per simulation step
(def GROW_DURATION 2)
(def DECAY_RATE 3) ; pixels per simulation step
(def DECAY_DURATION 3]
(def SUSTAIN_TIME 2) ; TODO: Add sustain time

(def explosions [])


;(defn create-explosion "Create new explosion on-screen"
;      [pos initial_radius start_time growth_rate grow_duration decay_rate decay_duration]
;      (set! explosions (conj explosions
;      {:pos pos :radius initial_radius :start_time start_time :growth_rate growth_rate :grow_duration grow_duration :decay_rate decay_rate :decay_duration decay_duration}))
;      explosions
;)

(defn create-explosion "Create a new explosion on-screen" [pos start_time]
      (set! explosions (conj explosions
      {:pos pos :start_time start_time :radius INITIAL_RADIUS :growth_rate GROWTH_RATE :grow_duration GROW_DURATION :decay_rate DECAY_RATE :decay_duration DECAY_DURATION}))
      explosions
)

(defn step-explosions [now]
      (set! explosions (for [e explosions :when (< (now-start_time (+ (get e :grow_duration) (get e :decay_duration)))]
      (cond
            (< (now-start_time (get e :grow_duration))) (update e :radius + (get e :growth_rate))
            (< (now-start_time (+ (get e :decay_duration) (get e :decay_duration))) (update e :radius - (get e :decay_rate))
      )
      explosions
)
