#lang scheme

(require mred/mred
         (prefix-in gl- sgl/sgl))

(define board%
  (class* canvas% ()
    
    (inherit refresh with-gl-context swap-gl-buffers get-parent get-width get-height)
    
    (define drawing-thunk (lambda () (void)))
    
    (define/public (set-drawing-thunk thunk)
      (set! drawing-thunk thunk))
    
    (define (common-setup)
      (gl-viewport 0 0 (get-width) (get-height))
      (gl-matrix-mode 'projection)
      (gl-load-identity)
      (gl-ortho -1 1 -1 1 -1 1)
      
      (gl-matrix-mode 'modelview)
      (gl-load-identity)
      ;; Turn off depth test = 2D drawing
      (gl-disable 'depth-test)
      ;; Don't cull anything, so we can flip around the y axis and still render
      (gl-disable 'cull-face)
      
      ;; Turn up quality
      (gl-enable 'blend)
      (gl-blend-func 'src-alpha 'one-minus-src-alpha)
      (gl-enable 'point-smooth)
      (gl-enable 'line-smooth)
      (gl-enable 'polygon-smooth)
      (gl-hint 'point-smooth-hint 'nicest)
      (gl-hint 'line-smooth-hint 'nicest)
      (gl-hint 'polygon-smooth-hint 'nicest)
      (gl-enable 'multisample)
      
      ;; Clear everything to white background
      ;; Comment this if you want to see funky junk 
      (gl-clear-color 1. 1. 1. 1.)
      (gl-clear 'color-buffer-bit)
      
      ;; Default color is black
      (gl-color 0. 0. 0. .9))
    
    (define/override (on-size width height)
      (with-gl-context
       (lambda ()
         (common-setup)
         (refresh))))
    
    (define/override (on-paint)
      (with-gl-context
       (lambda ()
         (printf "In on-paint\n")
         (gl-clear-color 1. 1. 1. 1.)
         (gl-clear 'color-buffer-bit)
         (drawing-thunk)
         (printf "Drawing thunk run\n")
         (swap-gl-buffers)
         (gl-flush))))
    
    (super-instantiate ()
      (style '(gl no-autoclear))
      (gl-config
       (let ([c (new gl-config%)])
         (send c set-multisample-size 4)
         c)))))

(define (draw board action)
  (send board set-drawing-thunk action))

(provide
 board%
 draw)
