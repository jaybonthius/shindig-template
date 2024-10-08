#lang racket

(provide raw)

(define (process-expr expr)
  (cond
    [(pair? expr)
     (cond
       ;; Handle unquote expressions
       [(eq? (car expr) 'unquote)
        (define val (cadr expr))
        (format "~s" val)]
       ;; Handle quote expressions
       ;; Process the quoted content directly
       [(eq? (car expr) 'quote)
        (define quoted-expr (cadr expr))
        (process-expr quoted-expr)]
       ;; Recursively process the list
       [else (string-join " " #:before-first "(" #:after-last ")")])]
    ;; Handle strings
    [(string? expr) (format "\"~a\"" expr)]
    ;; Handle symbols
    [(symbol? expr) (format "~a" expr)]
    ;; Handle other data types
    [else (format "~a" expr)]))

(define (raw expr)
  (string-append "@" (process-expr expr)))
