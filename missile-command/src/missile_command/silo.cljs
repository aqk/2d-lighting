(ns missile-command.silo)

(require '[missile-command.util :as util])

; TODO: Use dimensions of the screen to layout the silos
; TODO: Move screen dimensions to central location

; Begin screen-specific vars
(def SILO_HEIGHT 20)
(def SILO_WIDTH 20)

; End screen-specific vars

; In HTML canvas the coordinate (0, 0) is at the upper-left corner of the canvas
; Therefore, we use :pos to mean the upper-left corner of sprites

(def MAX_SILO_AMMO 10)
(def SILO_Y_POS (- (- util/SCREEN_HEIGHT SILO_HEIGHT) util/GROUND_HEIGHT))

; :name can double as the key used to fire from that silo
(def all_silos [{:alive true :ammo MAX_SILO_AMMO :name "a" :pos [SILO_WIDTH SILO_Y_POS]}
     	          {:alive true :ammo MAX_SILO_AMMO :name "s" :pos [(/ (- util/SCREEN_WIDTH SILO_WIDTH) 2) SILO_Y_POS]}
		            {:alive true :ammo MAX_SILO_AMMO :name "d" :pos [(- util/SCREEN_WIDTH SILO_WIDTH) SILO_Y_POS]} ])


;(defn set-silo-ammo)
;(defn get-silo-ammo)

; set silo ammo to zero
(defn disable-silo [name]
  (set!
   all_silos
   (map
    (fn silo-disable [s]
      (if (= (s :name) name) (update s util/const-update :alive false) s)
      )
    )
   )
  )

(defn get-silos [] all_silos)

; set silo ammo to MAX_SILO_AMMO
;; (defn enable-silo)

;; (defn fire-from-silo
;;       [silo_name target_pos]
;;       ; get silo
;;       ; if ammo == 0, return
;;       ;
;; )
