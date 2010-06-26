#lang scheme

;; struct color : [0, 360) [0, 1] [0, 1] [0, 1]
(define-struct colour (h s l a) #:transparent)

(define (in-range? x l h)
  (and (<= l x) (<= x h)))

(define (clip x l h)
  (cond
   [(< x l) l]
   [(> x h) h]
   [else x]))

;; valid-colour? : colour -> boolean
(define valid-colour?
  (match-lambda
   [(struct colour (h s l a))
    (and (in-range? h 0 359)
         (in-range? s 0 1)
         (in-range? l 0 1)
         (in-range? a 0 1))]))

;; normalise-colour : colour -> colour
(define normalise-colour
  (match-lambda
   [(struct colour (h s l a))
    (make-colour (modulo h 360)
                 (clip s 0 1)
                 (clip l 0 1)
                 (clip a 0 1))]))

;; hsl : number number number -> colour
(define (hsl h s l)
  (hsla h s l 1))

;; hsla : number number number number -> colour
(define (hsla h s l a)
  (normalise-colour (make-colour h s l a)))

;; rgb : number number number -> colour
(define (rgb r g b)
  (rgba r g b 1))

;; rgba : number number number number -> colour
(define (rgba r g b a)
  (let* ([r (clip r 0 1)]
         [g (clip g 0 1)]
         [b (clip b 0 1)]
         [a (clip a 0 1)]
         [mx (max r g b)]
         [mn (min r g b)]
         [h
          (cond
           [(= mx mn) 0]
           [(and (= mx r) (<= g b)) (* 60 (/ (- g b) (- mx mn)))]
           [(and (= mx r) (> g b))  (+ (* 60 (/ (- g b) (- mx mn))) 360)]
           [(= mx g)                (+ (* 60 (/ (- b r) (- mx mn))) 120)]
           [else                    (+ (* 60 (/ (- r g) (- mx mn))) 240)])]
         [l (/ (+ mx mn) 2)]
         [s
          (cond
           [(or (zero? l)           (= mx mn)) 0]
           [(and (< 0 l) (< l 1/2)) (/ (- mx mn) (+ mx mn))]
           [else                    (/ (- mx mn) (- 2 (+ mx mn)))])])
    ;; rounding error can bring s and l outside of range
    (normalise-colour (make-colour (modulo (round h) 360) s l a))))

;; colour->rgba : colour -> (values number number number number)
(define colour->rgba
  (match-lambda
   [(struct colour (h s l a))
    (define (normalise x)
      (cond
       [(< x 0) (add1 x)]
       [(> x 1) (sub1 x)]
       [else    x]))
    (define (colourise x p q)
      (cond
       [(< x 1/6) (+ p (* 6 x (- q p)))]
       [(< x 1/2) q]
       [(< x 2/3) (+ p (* 6 (- 2/3 x) (- q p)))]
       [else      p]))
    (cond
     [(zero? s) (values l l l a)]
     [else
      (let* ([q (cond [(< l 1/2) (* l (add1 s))]
                      [else (+ l (- s (* l s)))])]
             [p (- (* 2 l) q)]
             [h (/ h 360)]
             [tr (normalise (+ h 1/3))]
             [tg h]
             [tb (normalise (- h 1/3))])
        (values (colourise tr p q)
                (colourise tg p q)
                (colourise tb p q)
                a))])]))

(provide
 valid-colour?

 hsl
 hsla
 rgb
 rgba
 
 colour
 colour?
 colour-h
 colour-s
 colour-l
 colour-a

 colour->rgba)