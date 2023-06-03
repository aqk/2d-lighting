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


(let [cc (canvas-context)]
  (canvas/on-frame
   (fn my-task []
     (canvas/color-fill cc "#327")
     (canvas/rect cc 0 0 800 600)
     (canvas/fill cc)
     )
   )
  )

(defn average [a b]
  (/ (+ a b) 2.0))
