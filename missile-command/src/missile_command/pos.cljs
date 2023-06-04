(ns missile-command.pos)

; positions are represented as maps of the form {:x 0 :y 2}

(defn distance [a b]
  (let [x (- (get a :x) (get b :x))
        y (- (get a :y) (get b :y))]
    (Math/sqrt (+ (* x x) (* y y)))
    )
  )

; rectangles are {:x :y :width :height}
(defn is-within-rect [pos rect]
      (and  (<= (get rect :x) (get pos :x))
      	    (<= (get rect :y) (get pos :y))
            (<= (get pos :x) (+ (get rect :x) (get rect :width)))
	    (<= (get pos :y) (+ (get rect :y) (get rect :height)))
      )
)

(defn rect-center [rect]
      {:x (+ (get rect :x) (/ (get rect :width) 2))
       :y (+ (get rect :y) (/ (get rect :height) 2))}
)

; circles are {:pos :radius}
; (is-within-circle {:x 10 :y 10} {:pos {:x 11 :y 11} :radius 1}) => false
; (is-within-circle {:x 10 :y 10} {:pos {:x 11 :y 11} :radius 2}) => true
(defn is-within-circle [pos circle] (< (distance pos (get circle :pos)) (get circle :radius)))

; normalize_2D_vector
(defn norm [start_pos end_pos]
     (let [len (distance start_pos end_pos)
           vector {:x (- (get end_pos :x) (get start_pos :x)) :y (- (get end_pos :y) (get start_pos :y))}]
       {:x (/ (get vector :x) len) :y (/ (get vector :y) len)}
       )
  )

(defn calc-move-vector [pos target_pos move_distance]
  (let [n (norm pos target_pos)]
    (let [d (distance {:x 0 :y 0} n)]
      (if (> d move_distance)
        target_pos
        { :x (* (get n :x) move_distance) :y (* (get n :y) move_distance) }
        )
      )
    )
  )

(defn move-along-line [pos target-pos speed time]
  (let [move-distance (* speed (/ time 1000.0))]
    (let [target (calc-move-vector pos target-pos move-distance)]
      {:x (+ (target :x) (pos :x)) :y (+ (target :y) (pos :y))}
      )
    )
  )
