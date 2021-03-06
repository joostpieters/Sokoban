;=====================================================
; PRAM 2011
; Senaste ändring: modifierade power-up hantering 2011-05-13
;
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: player.scm
; Beskrivning: Definierar ADT:n Player
;=====================================================

; Klass
(define player%
  (class object%
    
    ; Konstruktorvariabler
    (init-field current-position
                current-board)
    
    ; Lokala fält
    (field (type 'player)
           (power-ups '())
           (power-up-queue 'empty)) ; Lista som lagrar power-up-procedurer
    
    ; #### Public ####
    
    ; Getters
    (define/public (get-position)
      current-position)
    
    (define/public (get-type)
      type)
    
    (define/public (get-power-ups)
      power-ups)
    
    (define/public (get-power-up-queue)
      power-up-queue)
    
    ; Setters
    (define/public (add-power-up! power-up)
      (set! power-ups (cons power-up power-ups)))
    
    (define/public (set-position! position)
      (set! current-position position))
    
    (define/public (set-board! board)
      (set! current-board board)
      (send board add-player! this))
    
    (define/public (clear-power-up-queue!)
      (set! power-up-queue 'empty))
    
    (define/public (remove-one-powerup!)
      (if (null? power-ups)
          (void)
          (set! power-ups (cdr power-ups)))
      (clear-power-up-queue!))
    
    (define/public (clear-power-ups!)
      (set! power-ups '()))
    
    ; Funktioner
    
    ; Flyttar spelaren
    (define/public (move! direction)
      (send current-board move! this direction))
    
    ; Använder spelarens power-up
    ; Om teleport läggs 'teleport som power-up-queue
    ; (om ej upptagen)
    (define/public (use-power-up)
      (if (null? power-ups)
          (void)
          (let* ((power-up (car power-ups))
                 (sub-type (send power-up get-sub-type)))
            (cond ((null? power-ups) (display "No power-up"))
                  ((and (eq? sub-type 'teleport)
                        (eq? power-up-queue 'empty))
                   (set! power-up-queue 'teleport)
                   (set! power-ups (cdr power-ups))
                   (send current-board add-use-power-up-history! power-up))
                  (else (void))))))
              
              
    (super-new)))