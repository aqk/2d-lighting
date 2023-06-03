
; TODO: Use dimensions of the screen to layout the silos
; TODO: Move screen dimensions to central location

; Begin screen-specific vars
(def SILO_HEIGHT 20)
(def SILO_WIDTH 20)

(def SCREEN_HEIGHT 600)
(def SCREEN_WIDTH 800)
; End screen-specific vars

; In HTML canvas the coordinate (0, 0) is at the upper-left corner of the canvas
; Therefore, we use :pos to mean the upper-right of sprites

(def MAX_SILO_AMMO 10)
(def SILO_Y_POS SCREEN_HEIGHT-SILO_HEIGHT)

; :name can double as the key used to fire from that silo
(def all_silos [{:ammo MAX_SILO_AMMO :name "a" :pos [0 SILO_Y_POS]}
     	        {:ammo MAX_SILO_AMMO :name "s" :pos [(SCREEN_WIDTH/2-SILO_WIDTH) SILO_Y_POS]}
		{:ammo MAX_SILO_AMMO :name "d" :pos [SCREEN_WIDTH-SILO_WIDTH SILO_Y_POS]} ])


;(defn set-silo-ammo)
;(defn get-silo-ammo)

; set silo ammo to zero
(defn disable-silo [name] )

; set silo ammo to MAX_SILO_AMMO
(defn enable-silo)


(defn fire-from-silo
      [silo_name target_pos]
      ; get silo
      ; if ammo == 0, return
      ;
)
