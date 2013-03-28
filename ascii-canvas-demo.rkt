#lang racket

(require
 racket/gui
 "ascii-canvas.rkt")

(define test-frame
  (new frame%
       [label "blah"]
       [style '(no-resize-border)]))
                        
(define test-ac
  (new ascii-canvas% 
       [parent test-frame]
       [width-in-characters 40]
       [height-in-characters 20]))

(send test-ac write-center "this is a test" 10)
(send test-ac write-center "this is a test in blue" 11 "blue")
(send test-ac write-center "this is a test in blue on yellow" 12 "blue" "yellow")

(send test-frame show #t)

(thread
 (lambda ()
   (let loop ()
     (send test-ac write 
           (integer->char (random 256)) 
           (random 40) (random 20) 
           (make-color (random 256) (random 256) (random 256))
           (make-color (random 256) (random 256) (random 256)))
     (sleep 0.1)
     (loop))))

(thread
 (lambda ()
   (let loop ()
     (send test-frame refresh)
     (sleep 0.5)
     (loop))))