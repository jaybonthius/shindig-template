#lang at-exp racket

(define current-id (make-parameter ""))
(define current-num (make-parameter 0))

(define (outer-function #:id [id ""] #:num [num 0] . content)
  (displayln (format "Outer function received ID: ~a, Num: ~a" id num))
  (define results
    (parameterize ([current-id id]
                   [current-num num])
      (map (lambda (x) 
                    (if (procedure? x) 
                        (x) 
                        x)) 
                  content)))
  results)

(define (inner-function)
  (lambda () 
    (let ([result (sqr (current-num))])
      result)))

; Example usage
(define (run-example)
  @outer-function[#:id "123" #:num 5]{
    @inner-function{}
    Other content
    @inner-function{}
  })

(run-example)