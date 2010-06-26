#lang scheme

(require (planet schematics/schemeunit:3/test)
         (planet dherman/stream:1/stream)
         "stream.ss")

(define/provide-test-suite stream-tests
  
  (test-case "naturals"
    (check-equal? (stream->list (stream-take 10 naturals))
                  (list 0 1 2 3 4 5 6 7 8 9)))
  
  (test-case "fibonaccis"
    (check-equal? (stream->list (stream-take 10 fibonaccis))
                  (list 1 1 2 3 5 8 13 21 34 55)))
  
  (test-case "make-uniform-ints"
    (map (lambda (x) (and (check < x 5) (check >= x 0)))
         (stream->list (stream-take 100 (make-uniform-ints 5)))))
  
  (test-case "make-uniform-discretes"
    (map (lambda (x) (check-pred (lambda (x) (or (eq? x 'a) (eq? x 'b) (eq? x 'c) (eq? x 'd))) x))
         (stream->list (stream-take 100 (make-uniform-discretes (vector 'a 'b 'c 'd)))))))
