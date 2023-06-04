
; TODO: Move screen dimensions to central location

; Begin screen-specific vars
(def CITY_HEIGHT 20)
(def CITY_WIDTH 20)

(def EDGE_BUFFER 50)
(def CENTER_BUFFER 10)
(def CITY_BUFFER 10)

(def SCREEN_HEIGHT 600)
(def SCREEN_WIDTH 800)
; End screen-specific vars

; In HTML canvas the coordinate (0, 0) is at the upper-left corner of the canvas
; Therefore, we use :pos to mean the upper-right of sprites

(def CITY_Y_POS SCREEN_HEIGHT-CITY_HEIGHT)

; :name can double as the key used to fire from that silo
(def all_cities [])

(defn auto-space [num start end] (for [n (range 3)] (+ (* (/ (- end start) (- num 1)) n) start)))

(defn init-cities []
      (set! all_cities (auto-space 3 SCREEN_EDGE_BUFFER (- (/ SCREEN_WIDTH 2) CENTER_BUFFER)))
      (set! all_cities (conj all_cities (auto-space 3 (+ (/ SCREEN_WIDTH 2) CENTER_BUFFER) (- SCREEN_WIDTH EDGE_BUFFER))))
)

; pos is position of enemy projectile
(defn is-city-hit [pos city_pos]
      (and  (<= city_pos.x pos.x)
      	    (<= city_pos.y pos.y)
            (<= pos.x city_pos.x+CITY_WIDTH)
	    (<= pos.y city_pos.y+CITY_HEIGHT)

      )
)

(defn destroy-city)
(defn rebuild-city)


