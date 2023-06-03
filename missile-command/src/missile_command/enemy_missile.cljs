
; Enemy missiles

(def SPEED 5) ; pixels per frame
(def all_missiles [])

(defn create-missile "Create new missile on-screen"
      [pos target_pos]
      (set! all_missiles (conj all_missiles {:pos [] :target_pos [] :speed SPEED}))
      ; todo: return missile?
)

; Note: we may have to destroy other types of enemies in future
(def destroy-missiles "Destroy on-screen missiles within given circle"
     [pos radius]
     
)
     