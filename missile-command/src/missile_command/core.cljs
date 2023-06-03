(ns missile-command.core)

(require '[helins.timer :as timer])
(require '[helins.canvas :as canvas])

(println "Hello world!")

(defn canvas-context []
  (-> js/document
      (.getElementById "canvas")
      (.getContext "2d")
      )
  )

(defn random-color []
  (str "#" (rand-int 10) "27")
  )

(defn new-game-state [] {
  :start (timer/now)
  })

(defn run-game [cc current-time game-state]
  (println (- current-time (game-state :start)))
  (canvas/color-fill cc "#327")
  (canvas/rect cc 0 0 800 600)
  (canvas/fill cc)
  )

(let [cc (canvas-context) global-game-state (atom (new-game-state))]
  (println global-game-state)
  (canvas/on-frame
   (fn my-task []
     (let [current-time (timer/now) game-state @global-game-state]
       (if game-state
         (run-game cc current-time game-state)
         ()
         )
       )
     )
   )
  )

(defn average [a b]
  (/ (+ a b) 2.0))
