#lang mzscheme

(require
 (lib "gl-vectors.ss" "sgl"))


;; Structures to represent basic shapes, so we can program
;; interesting effects over these shapes.  Will require a
;; change in the primitives to fully support this, but it's
;; a start.


;; A point is just a wrapper around a SGL vertex array,
;; which in turn is just a SRFI-4 vector.  We define this
;; interface so more meaningful code may be written.

;; make-point : number number -> point
(define (make-point x y)
  (gl-float-vector x y 0.0))

;; point? : any -> boolean
(define point? gl-float-vector?)

;; point-x : point -> number
(define (point-x point)
  (gl-vector-ref point 0))

;; point-y : point -> number
(define (point-y point)
  (gl-vector-ref point 1))
  
;; quad : point point point point
(define-struct quad (p0 p1 p2 p3))

;; triangle : point point point
(define-struct triangle (p0 p1 p2))

(provide
 (all-defined))