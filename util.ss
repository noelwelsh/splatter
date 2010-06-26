#lang scheme

(require scheme/class
         mred/mred
         "board.ss")

;; make-board : int int -> gl-context<%>
(define (make-board x y)
  (let* ([f (new frame%
                 (label "Spatter!")
                 (width x)
                 (height y))]
         [c (new board%
                 (parent f))])
    (send f show #t)
    c))

(provide
 make-board)
