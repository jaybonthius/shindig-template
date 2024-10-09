#lang racket/base

(require pollen/render
         pollen/tag
         racket/file
         racket/match
         racket/string
         "../utils.rkt")

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

(define ($ latex)
  `(script [(type "math/tex; mode=text")] ,(format "\\(~a\\)" latex)))

(define ($$ latex)
  `(div [(class "flex justify-center")]
        (div [(class "inline-block")]
             (script [(type "math/tex; mode=display")] ,(format "\\[~a\\]" latex)))))

(define (xref #:type type #:uid uid)
  ; TODO: Implement
  `(xref ,uid))

(define (render-component xexpr type uid)
  (define prefix (symbol->string type))
  (define output-dir (build-path (current-directory) prefix))
  (define temp-dir (build-path output-dir "temp"))
  (define temp-path (build-path temp-dir (string-append uid ".html.pm")))
  (define output-path (build-path output-dir (string-append uid ".html")))
  (define template-path (build-path output-dir "template.html.p"))

  (make-directory* temp-dir)
  (make-directory* output-dir)

  (with-output-to-file temp-path
                       (lambda ()
                         (displayln "#lang pollen")
                         (display "◊")
                         (write (quote-xexpr-attributes xexpr)))
                       #:exists 'replace)

  (render-to-file-if-needed temp-path template-path output-path)
  output-path

  "")

(define (default-placeholder type uid)
  `(div ((hx-get ,(format "/get-~a/~a" (symbol->string type) uid)) (hx-trigger "load")
                                                                   (hx-target "this"))
        "Loading..."))

(define (to-kebab-case str)
  (string-join (map string-downcase (regexp-split #rx"[^a-zA-Z0-9]+" (string-trim str))) "-"))

(define (definition #:name name #:uid (uid "") . body)
  (set! uid (if (string=? uid "") (to-kebab-case name) uid))

  (define type 'definition)
  (define load-asynchronously? #t)
  (define component `(div (div [(class "block")] (strong ,name)) (div ,@body)))
  (define placeholder (default-placeholder type uid))

  ; TODO: add xref information to sqlite file
  (render-component component type uid)
  (if load-asynchronously? placeholder component))
