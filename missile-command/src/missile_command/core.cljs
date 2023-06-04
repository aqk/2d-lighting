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
  :mouse '()
  :states [(new-menu-state) {:kind "game"}]
  })

(defn draw-game [cc game]
  (canvas/color-fill cc "#850")
  (canvas/rect-fill cc 0 550 800 50)
  )

(defn draw-mouse [cc x y]
  (canvas/color-fill cc "#fff")
  (canvas/text-fill
   cc
   (- x 1) (- y 1)
   (str x "x" y)
   )
  )

(defn is-mouse-down [game-state]
  (if (= (game-state :mouse) '())
    false
    (let [m (game-state :mouse)]
      (m :down)
      )
    )
  )

(defn draw-screen [cc game-state]
  (canvas/color-fill cc "#327")
  (canvas/rect-fill cc 0 0 800 600)

  (let [game-stack (first (game-state :states))]
    (if (= (game-stack :kind) "menu")
      (draw-menu cc game-stack)
      (draw-game cc game-stack)
      )
    )

  (let [gs-mouse (game-state :mouse)]
    (if (is-mouse-down game-state) (draw-mouse cc (gs-mouse :x) (gs-mouse :y)) '())
    )
  )

(defn const-update [a b] b)

(defn pop-state [game-state]
  (let [new-state
        (update game-state :states const-update (rest (game-state :states)))]
    new-state
    )
  )

(defn run-game-mode [cc current-time game-state]
  '()
  )

(defn run-menu-mode [cc current-time game-state]
  (if (is-mouse-down game-state)
    (pop-state game-state)
    '()
    )
  )

(defn run-game [cc current-time game-state]
  (let [new-state
        (let [game-stack (first (game-state :states))]
          (if (= (game-stack :kind) "menu")
            (run-menu-mode cc current-time game-state)
            (run-game-mode cc current-time game-state)
            )
          )
        ]
    (draw-screen cc game-state)
    new-state
    )
  )

(defn game-mouse-up [global-game-state]
  (swap! global-game-state assoc :mouse '())
  )

(defn game-mouse-down [global-game-state x y]
  (swap! global-game-state assoc :mouse {:x x :y y :down true})
  )

(defn game-mouse-move [global-game-state x y]
  (let [m (@global-game-state :mouse)]
    (if (= m '())
      ()
      (swap! global-game-state assoc :mouse {:x x :y y :down (m :down)})
      )
    )
  )

(let [ce (canvas-element)
      cc (canvas-context)
      global-game-state (atom (new-game-state))
      ]

  (-> ce
      (.addEventListener
       "mousedown"
       (defn mouse-down-handler [event]
         (let [x (. event -clientX)
               y (. event -clientY)]
           (game-mouse-down global-game-state x y)
           )
         )
       )
      )

  (-> ce
      (.addEventListener
       "mousemove"
       (defn mouse-move-handler [event]
         (let [x (. event -clientX)
               y (. event -clientY)]
           (game-mouse-move global-game-state x y)
           )
         )
       )
      )

  (-> ce
      (.addEventListener
       "mouseup"
       (defn mouse-up-handler [event]
         (game-mouse-up global-game-state)
         )
       )
      )

  (canvas/on-frame
   (fn my-task []
     (let [current-time (timer/now) game-state @global-game-state]
       (if game-state
         (let [new-state (run-game cc current-time game-state)]
           (if (= new-state '())
             '()
             (swap! global-game-state const-update new-state)
             )
           )
         )
       )
     )
   )
  )

