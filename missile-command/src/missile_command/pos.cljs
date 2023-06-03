
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

; circles are {:pos :radius}
; (is-within-circle {:x 10 :y 10} {:pos {:x 11 :y 11} :radius 1}) => false
; (is-within-circle {:x 10 :y 10} {:pos {:x 11 :y 11} :radius 2}) => true
(defn is-within-circle [pos circle] (< (distance pos (get circle :pos)) (get circle :radius)))
