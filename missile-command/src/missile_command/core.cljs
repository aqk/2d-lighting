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


(timer/every timer/main-thread
          1000
          (fn my-task []
            (let [cc (canvas-context)]
              (canvas/color-fill cc "#327")
              (canvas/clear cc 0 0 800 600)
              )
            (println "Hello world!")
            )
          )

(defn average [a b]
  (/ (+ a b) 2.0))
