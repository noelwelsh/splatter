#lang scheme

(require (planet cce/fasttest:2/random)
         (planet cce/fasttest:2/schemeunit)
         (planet schematics/schemeunit:3/test)
         "colour.ss")

(define/provide-test-suite colour-tests
  
  (test-randomly "hsl" 100
    ([h (choose-int-between 0 1000)]
     [s (* 10 (random))]
     [l (* 10 (random))])
    (check-pred valid-colour? (hsl h s l)))
  
  (test-randomly "hsla" 100
    ([h (choose-int-between 0 1000)]
     [s (* 10 (random))]
     [l (* 10 (random))]
     [a (* 10 (random))])
    (check-pred valid-colour? (hsla h s l a)))
  
  (test-randomly "rgb" 100
    ([r (* 10 (random))]
     [g (* 10 (random))]
     [b (* 10 (random))])
    (check-pred valid-colour? (rgb r g b)))
  
  (test-randomly "rgba" 100
    ([r (* 10 (random))]
     [g (* 10 (random))]
     [b (* 10 (random))]
     [a (* 10 (random))])
    (check-pred valid-colour? (rgba r g b a)))
  
  (test-randomly "Grey is always hue 0" 100
    ([x (random)])
    (check-equal? (colour-h (rgb x x x)) 0))
  
  (test-case "Hue of 360 is wrapped to 0"
    (check-equal? (colour-h (hsl 360 0 0)) 0)
    (check-equal? (colour-h (hsl 720 0 0)) 0)
    (check-equal? (colour-h (hsl 1080 0 0)) 0))
  
  (test-case "colour->rgba for grey"
    (let-values (([r g b a] (colour->rgba (hsl 13 0 0.5))))
      (check-equal? r 0.5)
      (check-equal? g 0.5)
      (check-equal? b 0.5)
      (check-equal? a 1)))
  
  ;; values taken from Wikipedia
  (test-case "colour->rgba"
    (let-values (([r g b a] (colour->rgba (hsl 0 1 0.5))))
      (check-equal? r 1.0)
      (check-equal? g 0.0)
      (check-equal? b 0.0)
      (check-equal? a 1))
    (let-values (([r g b a] (colour->rgba (hsl 120 1 0.75))))
      (check-equal? r 0.5)
      (check-equal? g 1.0)
      (check-equal? b 0.5)
      (check-equal? a 1))
    (let-values (([r g b a] (colour->rgba (hsl 240 1 0.25))))
      (check-equal? r 0.0)
      (check-equal? g 0.0)
      (check-equal? b 0.5)
      (check-equal? a 1))))
