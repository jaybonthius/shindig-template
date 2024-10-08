#lang racket/base

(require pollen/tag)

(provide (all-defined-out))

(define-syntax-rule (define-heading heading-name tag)
  (define heading-name (default-tag-function tag #:class (symbol->string 'heading-name))))

(define-heading chapter 'h1)
(define-heading section 'h2)

(define (strong . text)
  `(strong ,@text))

(define (bold . text)
  `(strong ,@text))

(define (emph . text)
  `(em ,@text))

; TODO: I decided that I don't wanna do paragraph links, but there's some good content in here that I should save for other uses.
; (define (p #:uid [uid ""] . text)
;   `(div [(class "relative group")]
;     (aside [(class "absolute -left-10 top-1 opacity-0 group-hover:opacity-100 transition-opacity")]
;       (a [(href ,(format "#~a" uid)) (class "text-gray-400 hover:text-gray-600 dark:text-gray-500 dark:hover:text-gray-300")]
;         (i [(class "fa-solid fa-link")])
;       )
;     )
;     (p ,@text))
; )
