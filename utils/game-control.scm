;================================================================
; PRAM 2011
; Senaste ändring: Kontroller för stopp och star av musik
; 2011-05-10
;
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: game-control.scm
; Beskrivning: Hjälpfunktioner för programflödet
;================================================================

; Hämtar inladdad rådata
(define (get-board-data level)
  (vector-ref *game-data* level))

; Återställer den nuvarande nivåns originaltillstånd
(define (load-level!)
  (set! *current-board* (parse-level-data (get-board-data *current-level*)))
  (send *player* set-board! *current-board*)
  (send *player* clear-power-ups!)
  (send *counter* set-level! *current-level*)
  (send *game-canvas* redraw)
  (send *game-sidebar* draw)
  (send *game-canvas* focus))

; Återställer nuvarande nivån
(define (reset-level!)
  (if *main-menu-active?*
      (void)
      (load-level!)))

; Laddar nästa nivå
(define (next-level!)
  (if (= *current-level* (- *number-of-maps* 1))
      (main-menu!)
      (begin
        (set! *current-level* (+ *current-level* 1))
        (load-level!))))

; Laddar tidigare nivå
(define (previous-level!)
  (set! *current-level* (- *current-level* 1))
  (load-level!))

; Startar om från första nivån
(define (restart-game!)
  (if *main-menu-active?*
      (void)
      (begin
        (set! *current-level* 0)
        (load-level!))))

(define (start-new-game!)
  (send *main-menu-animation-timer* stop)
  (set! *main-menu-active?* #f)
  (set! *current-level* 0)
  (load-level!)
  (stop-music!)
  (send player-name-dialog show #t))

(define (main-menu!)
  (if (not *music-on?*)
      (play-music!)
      (void))
  (send *main-menu-animation-timer* start 50)
  (set! *main-menu-active?* #t)
  (send *main-menu* set-on-main-menu! #t)
  (send *game-canvas* stop-all-animations)
  (send *main-menu* draw)
  (send *game-sidebar* draw-main-menu))

(define (quit!)
  (stop-music!)
  (send *main-menu-animation-timer* stop)
  (set! *main-menu-active?* #f)
  (send *game-canvas* stop-all-animations)
  (send *game-frame* show #f))

(define (play-music!)
  (set! *music-on?* #t)
  (send *game-music-timer* notify)
  (send *game-music-timer* start 118375 #t))

(define (stop-music!)
  (set! *music-on?* #f)
  (play-sound "data/sounds/silence.wav" #t)
  (send *game-music-timer* stop))