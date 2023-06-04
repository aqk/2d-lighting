(ns missile-command.util)

(defn const-update [a b] b)

(defn x-of [v] (first v))
(defn y-of [v] (first (rest v)))

(def SCREEN_HEIGHT 600)
(def SCREEN_WIDTH 800)

(def GROUND_HEIGHT 50)
