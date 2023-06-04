(ns missile-command.core)

(require '[helins.timer :as timer])
(require '[helins.canvas :as canvas])
(require '[missile-command.util :as util])
(require '[missile-command.silo :as silo])
(require '[missile-command.cities :as cities])
(require '[missile-command.sim :as sim])

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
  :states [(new-menu-state) (sim/init-game-state)]
  })

(cities/init-cities)

(defn draw-silo [cc s]
  (canvas/color-fill cc "#850")
  (if (s :alive)
    (let [p (s :pos)]
      (let [x (util/x-of p)
            y (util/y-of p)
            HSW (/ silo/SILO_WIDTH 2)
            SH silo/SILO_HEIGHT]
        (canvas/begin cc (- x HSW) (+ y SH))
        (canvas/line cc x y)
        (canvas/line cc (+ x HSW) (+ y SH))
        (canvas/close cc)
        (canvas/fill cc)
        )
      )
    ()
    )
  )

(defn draw-city [cc c]
  (canvas/color-fill cc "#32a")
  (if (c :alive)
    (let [x (c :x) y (c :y) HCW (/ cities/CITY_WIDTH 2) CH cities/CITY_HEIGHT]
      (canvas/rect-fill cc (- x HCW) y HCW CH)
      )
    ()
    )
  )

(defn mark-point [cc color x y]
  (canvas/color-fill cc color)
  (canvas/rect-fill cc (- x 1) (- y 1) 3 3)
  )

(defn draw-player-missile [cc pm]
  (let [pos (pm :pos) tp (pm :target_pos)]
    (let [x (pos :x) y (pos :y)]
      (mark-point cc "#f22" x y)
      )
    (let [x (tp :x) y (tp :y)]
      (mark-point cc "#f88" x y)
      )
    )
  )

(defn draw-game [cc game]
  (canvas/color-fill cc "#850")
  (canvas/rect-fill cc 0 550 800 50)

  ;; Draw game stuff
  (do
    (dorun
     (for [s (silo/get-silos)]
       (draw-silo cc s)
       )
     )
    )

  (do
    (dorun
     (for [c (game :cities)]
       (draw-city cc c)
       )
     )
    )

  (do
    (dorun
     (for [p (game :player_missiles)]
       (draw-player-missile cc p)
       )
     )
    )

  ;; Overlay score
  (canvas/color-fill cc "#fff")
  (canvas/text-fill cc 10 10 (str "Score: " (game :score)))
  (canvas/text-fill cc 700 10 (str "Wave: " (game :wave)))
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

(defn pop-state [game-state]
  (let [new-state
        (update-in game-state [:states] util/const-update (rest (game-state :states)))]
    new-state
    )
  )

(defn update-state [game-state new-state]
  (let [new-stack (cons new-state (rest (game-state :states)))]
    (let [new-state (update-in game-state [:states] util/const-update new-stack)]
      new-state
      )
    )
  )

(defn sim-mouse-state [m]
  (if (= m '())
    {:left_click false
     :pos {:x -1000000 :y -1000000}
     }
    {:left_click (and (not (m :was-down)) (m :down))
     :pos m
     }
    )
  )

(defn retire-mouse-click [new-state]
  (let [mouse (new-state :mouse)]
    (if (= mouse '())
      new-state
      (let [updated-mouse (update-in mouse [:was-down] util/const-update (mouse :down))]
        (let [u (update-in new-state [:mouse] util/const-update updated-mouse)]
          u
          )
        )
      )
    )
  )

(defn run-game-mode [cc current-time game-state]
  (let [our-state (first (game-state :states))
        mouse-state (sim-mouse-state (game-state :mouse))]
    (let [new-state (sim/step-game-state mouse-state our-state)]
      (retire-mouse-click (update-state game-state new-state))
      )
    )
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
  (swap! global-game-state assoc :mouse {:x x :y y :down true :was-down false})
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
             (swap! global-game-state util/const-update new-state)
             )
           )
         )
       )
     )
   )
  )

