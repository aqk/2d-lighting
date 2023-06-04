(ns missile-command.pos)

; positions are represented as maps of the form {:x 0 :y 2}

(defn distance [a b] (def x (- (get a :x) (get b :x))) (def y (- (get a :y) (get b :y))) (Math/sqrt (+ (* x x) (* y y))))

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
     let [len (distance start_pos end_pos)
     vector {(- (get end_pos :x) (get start_pos :x)) (- (get end_pos :y) (get start_pos :y))}]
     {:x (/ (get vector :x) len) :y (/ (get vector :y) len)}
)

(defn calc-move-vector [pos target_pos move_distance]
      (def n (norm pos target_pos))
      { (* (get n :x) move_distance) (* (get n :y) move_distance) }
)


(defn move-along-line [pos target-pos speed] pos)
