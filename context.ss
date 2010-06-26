#lang scheme

;; struct state : colour symbol
(define-struct context (colour shape))

(provide
 context
 context?
 make-context
 context-colour
 context-shape)
