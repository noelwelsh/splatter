(module geometry-test mzscheme
  
  (require (planet "test.ss" ("schematics" "schemeunit.plt" 2)))
  (require "geometry.ss")
  
  (provide geometry-tests)
  
  (define geometry-tests
    (test-suite
     "All tests for geometry"

     (test-case
      "points"
      (let ([p (make-point 1 2)])
        (check-= (point-x p) 1 0.00001)
        (check-= (point-y p) 2 0.00001)
        (check-true (point? p))
        (check-false (point? 'foo))))
     ))
  )