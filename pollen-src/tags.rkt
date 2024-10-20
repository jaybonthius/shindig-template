#lang racket/base

(require pollen/tag)

(provide (all-defined-out))

(define-syntax-rule (define-heading heading-name tag)
  (define heading-name (default-tag-function tag #:class (symbol->string 'heading-name))))

(require racket/runtime-path)
(define-runtime-path template.EXT "template.EXT")

(define-heading chapter 'h1)
(define-heading section 'h2)

; Basic text formatting
(define (strong . text)
  `(strong ,@text))

(define (emph . text)
  `(em ,@text))

(define (strike . text)
  `(del ,@text))

; Links
(define (link url . text)
  `(a ((href ,url)) ,@text))

; Images
(define (image src alt)
  `(img ((src ,src) (alt ,alt))))

; Code
(define (inline-code . code)
  `(code ,@code))

(define (code-block . code)
  `(pre (code ,@code)))

; Horizontal Rule
(define (horizontal-rule)
  `(hr))

