(module primitives mzscheme

  (require
   (prefix gl- (lib "sgl.ss" "sgl"))
   (lib "gl.ss" "sgl")
   (file "control.ss")
   (prefix base- (file "colour.ss"))
   (file "context.ss"))

  ;; shapes

  (define (square size)
    (pure0
     (lambda ()
       (gl-begin 'quads)
       (gl-vertex 0. 0. 0.)
       (gl-vertex 0. size 0.)
       (gl-vertex size size 0.)
       (gl-vertex size 0. 0.)
       (gl-end))))

  (define (circle radius)
    (pure0
     (lambda ()
       (let ([q (gl-new-quadric)])
         (gl-disk q 0 radius 32 4)))))

  (define (ring outer-radius inner-radius)
    (pure0
     (lambda ()
       (let ([q (gl-new-quadric)])
         (gl-disk q inner-radius outer-radius 32 4)))))
  
  (define (quad-strip xs ys)
    (pure0
     (lambda ()
       (gl-begin 'quad-strip)
       (for-each
        (lambda (x y) (gl-vertex x y 0))
        xs
        ys)
       (gl-end))))
  

  ;; transformations

  (define (scale x y)
    (pure0 (lambda () (gl-scale x y 1))))

  (define (move x y)
    (pure0 (lambda () (gl-translate x y 0.))))

  (define (rotate n)
    (pure0 (lambda () (gl-rotate n 0 0 1))))

  (define (flip n)
    (pure0 (lambda () (gl-rotate n 0 1 0))))

  ;; colour

  ;; hsla : [0, 360) [0, 1] [0, 1] [0, 1] [0, 1] -> Arrow
  (define (hsla h s l a)
    (lambda (arrow)
      (let ([c (base-hsla h s l a)])
        (let-values (([r g b a] (base-colour->rgba c)))
          (gl-color r g b a)
          (make-arrow (make-context c 'none) (void))))))

  ;; fade : [0, 1] -> Arrow
  (define (fade percentage)
    (lambda (arrow)
      (let* ([c (context-colour (arrow-state arrow))]
             [h (base-colour-h c)]
             [s (base-colour-s c)]
             [l (base-colour-l c)]
             [a (base-colour-a c)])
        ((hsla h s (+ l (* (- 1 l) percentage)) a) arrow))))


  ;; control

  (define (run-drawing action)
    (run->value action (make-context (base-hsla 0 0 0 .9) 'none) (void)))

  (provide
   square
   circle
   quad-strip
   ring
   
   move
   scale
   rotate
   flip

   hsla
   fade

   run-drawing)

  )