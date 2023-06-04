(ns missile-command.cities)

(require '[missile-command.util :as util])

; TODO: Move screen dimensions to central location

; Begin screen-specific vars
(def CITY_HEIGHT 20)
(def CITY_WIDTH 20)

(def EDGE_BUFFER 50)
(def CENTER_BUFFER 10)
(def CITY_BUFFER 10)

; End screen-specific vars

; In HTML canvas the coordinate (0, 0) is at the upper-left corner of the canvas
; Therefore, we use :pos to mean the upper-right of sprites

(def CITY_Y_POS (- (- util/SCREEN_HEIGHT util/GROUND_HEIGHT) CITY_HEIGHT))

; :name can double as the key used to fire from that silo
(def all_cities [])

(defn auto-space [num start end] (for [n (range 3)] (+ (* (/ (- end start) (- num 1)) n) start)))

(defn make-city [x]
  {:alive true
   :x x
   :y CITY_Y_POS
   }
  )

(defn init-cities []
  (set! all_cities (map make-city (auto-space 3 EDGE_BUFFER (- (/ util/SCREEN_WIDTH 2) CENTER_BUFFER))))
  (set! all_cities (concat all_cities (map make-city (auto-space 3 (+ (/ util/SCREEN_WIDTH 2) CENTER_BUFFER) (- util/SCREEN_WIDTH EDGE_BUFFER)))))
  )

; pos is position of enemy projectile
(defn is-city-hit [pos city_pos]
      (and  (<= city_pos.x pos.x)
      	    (<= city_pos.y pos.y)
            (<= pos.x city_pos.x+CITY_WIDTH)
	    (<= pos.y city_pos.y+CITY_HEIGHT)
      )
  )

(init-cities)

(defn get-cities [] all_cities)

;; (defn destroy-city)
;; (defn rebuild-city)
