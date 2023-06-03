(ns missile-command.core)

(require '[helins.timer :as timer])
(require '[helins.canvas :as canvas])

(defn canvas-element []
  (-> js/document
      (.getElementById "canvas")
      )
  )

(defn canvas-context []
  (-> js/document
      (.getElementById "canvas")
      (.getContext "2d")
      )
  )

(defn random-color []
  (str "#" (rand-int 10) "27")
  )

(defn text-size [cc text]
  (let [metrics (canvas/text-metrics cc text)]
    (let [ascent (. metrics -actualBoundingBoxAscent)
          descent (. metrics -actualBoundingBoxDescent)]
      {:x (. metrics -width) :y (+ ascent descent) :baseline ascent}
      )
    )
  )

(defn draw-menu [cc menu]
  (let [size (text-size cc "Start")]
    (let [left (- 400 (/ (size :x) 2)) top (- 300 (/ (size :baseline) 2))]
      (canvas/color-fill cc "#fff")
      (canvas/text-fill cc left top "Start")
      )
    )
  )

(defn new-menu-state [] {:kind "menu"})

(defn new-game-state [] {
  :start (timer/now)
  :states [(new-menu-state) {:kind "game"}]
  })

(defn draw-game [cc game]
  )

(defn draw-screen [cc game-state]
  (canvas/color-fill cc "#327")
  (canvas/rect cc 0 0 800 600)
  (canvas/fill cc)
  (let [game-stack (first (game-state :states))]
    (if (= (game-stack :kind) "menu")
      (draw-menu cc game-stack)
      (draw-game cc game-stack)
      )
    )
  )

(defn run-game [cc current-time game-state]
  (draw-screen cc game-state)
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
