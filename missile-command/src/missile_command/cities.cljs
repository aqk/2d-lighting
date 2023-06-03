
; TODO: Move screen dimensions to central location

; Begin screen-specific vars
(def CITY_HEIGHT 20)
(def CITY_WIDTH 20)

(def SCREEN_HEIGHT 600)
(def SCREEN_WIDTH 800)
; End screen-specific vars

; In HTML canvas the coordinate (0, 0) is at the upper-left corner of the canvas
; Therefore, we use :pos to mean the upper-right of sprites

(def CITY_Y_POS SCREEN_HEIGHT-CITY_HEIGHT)

; :name can double as the key used to fire from that silo
(def all_cities [])

(defn init-cities []
      (set! all_cities [for [x (range 3)] {:pos [40+(x*40) CITY_Y_POS]}])
      (set! all_cities (conj all_cities [for [x (range 3)] :pos [40+x*40 + (SCREEN_WIDTH/2) CITY_Y_POS]}]))
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


