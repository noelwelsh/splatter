#lang scheme

(require (planet schematics/schemeunit:3))

(require "geometry.ss")

(define/provide-test-suite geometry-tests
  
  (test-case "points"
    (let ([p (make-point 1 2)])
      (check-= (point-x p) 1 0.00001)
      (check-= (point-y p) 2 0.00001)
      (check-true (point? p))
      (check-false (point? 'foo)))))
