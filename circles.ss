#lang scheme

(require srfi/40/stream
         (planet williams/science:2/random-source)
         (planet williams/science:2/random-distributions)
         (planet sherman/stream:1/stream)
         "primitives.ss"
         "util.ss"
         "control.ss"
         "board.ss"
         "stream.ss")

;; Set the random source to random value, so a non-deterministic rendering is different each time
(random-source-randomize! (current-random-source))

(define circles
  (apply
   seq
   (stream->list
    (stream-take
     200
     (stream-map
      (lambda (x y n c)
        (branch (seq (move x y)
                     c
                     (ring (* .025 n) (* 0.022 n)))))
      (make-gaussians 0. .5)
      (make-gaussians 0. .5)
      (make-uniform-ints 10)
      (make-uniform-discretes
       (vector (hsla 200 1 .7 .7) (hsla 240 .8 .4 .8) (hsla 200 .7 .4 .5) (hsla 220 .8 .6 .6))))))))

(define b (make-board 600 600))
(draw b (lambda () (run-drawing circles)))
