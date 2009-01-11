(module stream-test mzscheme
  
  (require (planet "test.ss" ("schematics" "schemeunit.plt" 2))
           (file "stream.ss")
           (planet "stream.ss" ("dherman" "stream.plt" 1)))
  
  (provide stream-tests)
  
  (define stream-tests
    (test-suite
     "All tests for stream"

     (test-case
      "naturals"
      (check-equal? (stream->list (stream-take 10 naturals))
                    (list 0 1 2 3 4 5 6 7 8 9)))

     (test-case
      "fibonaccis"
      (check-equal? (stream->list (stream-take 10 fibonaccis))
                    (list 1 1 2 3 5 8 13 21 34 55)))

     (test-case
      "make-uniform-ints"
      (map (lambda (x) (and (check < x 5) (check >= x 0)))
           (stream->list (stream-take 100 (make-uniform-ints 5)))))

     (test-case
      "make-uniform-discretes"
      (map (lambda (x) (check-pred (lambda (x) (or (eq? x 'a) (eq? x 'b) (eq? x 'c) (eq? x 'd))) x))
           (stream->list (stream-take 100 (make-uniform-discretes (vector 'a 'b 'c 'd))))))
     ))
  )