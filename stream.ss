#lang scheme

(require srfi/40/stream
         (planet dherman/stream:1/stream)
         (planet williams/science:2/random-distributions/discrete)
         (planet williams/science:2/random-distributions/gaussian)
         (planet williams/science:2/random-source))

(define naturals
  (stream-cons 0 (stream-map add1 naturals)))

(define (make-fibonacci n n-1)
  (let ([n+1 (+ n n-1)])
    (stream-cons n+1
                 (make-fibonacci n+1 n))))

(define fibonaccis
  (stream-cons 1 (stream-cons 1 (make-fibonacci 1 1))))

(define gaussians
  (stream-cons (random-gaussian 0. 1.)
               (stream-map (lambda (x) (random-gaussian 0. 1.)) gaussians)))

(define (make-uniform-ints n)
  (stream-cons (random-uniform-int n)
               (make-uniform-ints n)))

(define (make-gaussians mean var)
  (stream-cons (random-gaussian mean var)
               (make-gaussians mean var)))

;; make-uniform-discretes : (vectorof 'a) -> (streamof 'a)
(define (make-uniform-discretes choices)
  (define (discrete-aux d)
    (stream-cons (vector-ref choices (random-discrete d))
                 (discrete-aux d)))
  (discrete-aux (make-discrete (make-vector (vector-length choices) 1))))

(provide
 naturals
 fibonaccis
 gaussians
 
 make-uniform-ints
 make-gaussians
 make-uniform-discretes)