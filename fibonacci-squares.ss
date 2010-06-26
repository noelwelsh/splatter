#lang scheme

(require srfi/40/stream
         (planet williams/science:2/random-distributions)
         (planet williams/science:2/random-source)
         (planet dherman/stream:1/stream)
         "primitives.ss"
         "util.ss"
         "control.ss"
         "board.ss"
         "stream.ss")

;; Set the random source to random value, so a non-deterministic rendering is different each time
(random-source-randomize! (current-random-source))

(define fibonacci-squares
  (apply
   seq
   (stream->list
    (stream-take
     9
     (stream-map
      (lambda (size)
        (seq (square size)
             (move size size)
             (fade 0.2)
             (rotate 270)))
      (stream-drop 2 fibonaccis))))))

(define b (make-board 600 600))
(draw b (lambda () (run-drawing (seq (move -0.5 -0.2)
                                     (scale 0.05 0.05)
                                     (hsla 240 1 0.5 1)
                                     ;; First two squares (they're special)
                                     (square 1) (fade 0.2) (move 1 0) (square 1) (move 1 0)
                                     (fade 0.2) (rotate 180)
                                     fibonacci-squares))))
