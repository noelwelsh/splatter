(module util mzscheme

  (require
   (lib "class.ss")
   (lib "mred.ss" "mred")
   (file "board.ss"))

  ;; make-board : int int -> gl-context<%>
  (define (make-board x y)
    (let* ([f (new frame%
                   (label "Spatter!")
                   (width x)
                   (height y))]
           [c (new board%
                   (parent f))])
      (send f show #t)
      c))


  (provide
   make-board)

  )