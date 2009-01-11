(module control mzscheme

  (require
   (lib "list.ss")
   (prefix gl- (lib "sgl.ss" "sgl"))
   (lib "gl.ss" "sgl")
   (planet "random-distributions/discrete.ss" ("williams" "science.plt" 2)))
  
  ;; Arrowish control operators
  
  ;; struct arrow : state any
  (define-struct arrow (state value))
  
  (define (seq . actions)
    (lambda (arrow)
      (foldl
       (lambda (action arrow)
         (action arrow))
       arrow
       actions)))
  
  (define (pure fn)
    (lambda (arrow)
      (make-arrow (arrow-state arrow) (fn (arrow-value arrow)))))
  
  (define (pure0 fn)
    (lambda (arrow)
      (make-arrow (arrow-state arrow) (fn))))
  
  (define (return const)
    (pure0 (lambda () const)))
  

  (define (run action state value)
    (action (make-arrow state value)))
  
  (define (run->state action state value)
    (arrow-state (run action state value)))
  
  (define (run->value action state value)
    (arrow-value (run action state value)))

  (define-syntax choose
    (syntax-rules ()
      [(branch [weight action] ...)
       (let* ([weights (vector weight ...)]
              [actions (vector (lambda () action) ...)]
              [distrib (make-discrete weights)])
         (lambda (arrow)
           (let ([choice (random-discrete distrib)])
             (((vector-ref actions choice)) arrow))))]))

  (define (branch . branches)
    (lambda (arrow)
      (foldl
       (lambda (branch result)
         (gl-push-matrix)
         (glPushAttrib GL_CURRENT_BIT)
         (begin0
             (branch arrow)
           (glPopAttrib)
           (gl-pop-matrix)))
       (void)
       branches)))
      
  (provide
   arrow
   arrow?
   make-arrow
   arrow-state
   arrow-value

   seq
   branch
   choose
   pure
   pure0
   return

   run
   run->state
   run->value)
  )