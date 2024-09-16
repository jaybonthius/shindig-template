#lang racket/base

(require pollen/tag)

(provide (all-defined-out))

(define-syntax-rule (define-heading heading-name tag)
  (define heading-name
    (default-tag-function tag #:class (symbol->string 'heading-name))))

(define-heading chapter 'h1)
(define-heading section 'h2)

(define (strong . text)
  `(strong ,@text))

(define (emph . text)
  `(em ,@text))
