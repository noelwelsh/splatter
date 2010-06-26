#lang scheme

(require
 ;(lib "mred.ss" "mred")
 ;(prefix gl- (lib "sgl.ss" "sgl"))
 "primitives.ss"
 "util.ss"
 "control.ss"
 "board.ss"
 (planet williams/science:2/random-source)
 (planet williams/science:2/random-sdistributions))

;; Set the random source to random value, so a non-deterministic rendering is different each time
(random-source-randomize! (current-random-source))

(define b (make-board 600 600))

(define (squares depth)
  (if (zero? depth)
      (return 'done)
      (seq
       (square 0.2)
       (move 0.2 0.2)
       (scale 0.9 0.9)
       (rotate 20)
       (fade 0.2)
       (squares (sub1 depth)))))

(define (tree depth)
  (if (zero? depth)
      (return 'done)
      (choose
       [1 (seq
           (branch
            (seq (scale 0.4 1.2)
                 (circle 0.1)))
           (move 0.025 0.07)
           (scale .97 .97)
           (tree (sub1 depth)))]
       [.1 (seq (flip 180) (tree (sub1 depth)))]
       [.2 (branch
            (seq (rotate -10) (tree (sub1 depth)))
            (seq (rotate 30)
                 (scale 0.7 0.7)
                 (tree (sub1 depth))))])))

(define (handdrawn-line x y scale width steps)
  (define (square x) (* x x))
  (define x-step (/ x steps))
  (define y-step (/ y steps))
  ;; (a, b) defines the vector perpendicular to the vector (x, y)
  (define-values (a b)
    (cond
      [(= x 0) (values 1 0)]
      [(= y 0) (values 0 1)]
      [else    (let ([b (sqrt (/ (square x) (+ (square x) (square y))))])
                 (values (- (/ (* b y) x)) b))]))
  (let loop ([xs null] [ys null] [step 0])
    (if (= step steps)
        (quad-strip (cons (+ x (* width a)) (cons x xs))
                    (cons (+ y (* width b)) (cons y ys)))
        (let* ([d (random-gaussian 0 scale)]
               [dx (* d a)]
               [dy (* d b)]
               [x (* step x-step)]
               [y (* step y-step)]
               [x0 (+ x dx)]
               [y0 (+ y dy)]
               [x1 (+ x dx (* width a))]
               [y1 (+ y dy (* width b))])
          (loop (cons x1 (cons x0 xs))
                (cons y1 (cons y0 ys))
                (add1 step))))))



'(draw b (lambda () (run-drawing 
                     (seq (move -0.1 -0.1)
                          ;(branch
                          ;    (squares 10)
                          ;    (seq (move .2 0) (rotate 90) (squares 10))
                          ;    (seq (move .2 .2) (rotate 180) (squares 10))
                          ;    (seq (move 0 .2) (rotate 270) (squares 10)))
                          (seq (scale 0.2 0.2) (tree 10))))))                    
'(draw b (lambda () (run-drawing (seq (move 0 -.9) (hsla 0 0 0 1) (tree 75)))))
(draw b (lambda () (run-drawing (seq (move -1 -1) (handdrawn-line 2 2 0.001 0.005 100)))))
'(draw b (lambda () (run-drawing (seq (square .5) (flip 180) (square .3)))))
