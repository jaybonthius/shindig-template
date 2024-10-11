#lang racket/base

(require db
         pollen/core
         pollen/render
         pollen/setup
         pollen/tag
         racket/file
         racket/match
         racket/path
         racket/string
         (prefix-in config: "../../common/config.rkt")
         "../utils.rkt")

(provide (all-defined-out))

(define-syntax-rule (define-heading heading-name tag)
  (define heading-name (default-tag-function tag #:class (symbol->string 'heading-name))))

(require racket/runtime-path)
(define-runtime-path template.EXT "template.EXT")

(define-heading chapter 'h1)
(define-heading section 'h2)

(define (filename-without-extension path)
  (define filename (path->string (file-name-from-path path)))
  (define name-parts (string-split filename "."))
  (if (> (length name-parts) 1) (car name-parts) filename))

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

(define (render-component xexpr type uid)
  (define prefix (symbol->string type))
  (define output-dir (build-path config:pollen-dir prefix))
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
                                                                   (hx-target "this")
                                                                   (hx-swap "outerHTML"))
        "Loading..."))

(define (to-kebab-case str)
  (string-join (map string-downcase (regexp-split #rx"[^a-zA-Z0-9]+" (string-trim str))) "-"))

(define (definition #:name name #:uid (uid "") . body)
  (set! uid (if (string=? uid "") (to-kebab-case name) uid))
  (define type 'definition)
  (define id (format "~a-~a" (symbol->string type) uid))
  (define load-asynchronously? #t)
  (define component `(div [(id ,id)] (div [(class "block")] (strong ,name)) (div ,@body)))
  (define placeholder (default-placeholder type id))

  (define source (filename-without-extension (hash-ref (current-metas) 'here-path)))

  (upsert-xref type id source)
  (render-component component type id)
  (if load-asynchronously? placeholder component))

(define (get-xref-source type id)
  (define db-connection
    (sqlite3-connect #:database (build-path config:sqlite-path "cross-references.sqlite")))

  (displayln (format "Checking for cross-reference: ~a ~a" type id))

  (define result
    (query-maybe-row db-connection
                     "select source from cross_references where type = $1 and id = $2"
                     (symbol->string type)
                     id))

  (displayln (format "Result: ~a" result))

  (vector-ref result 0))

(define (ref #:type type #:uid uid)
  (define id (format "~a-~a" (symbol->string type) uid))
  (define source (get-xref-source type id))
  (define current-source (filename-without-extension (hash-ref (current-metas) 'here-path)))

  (define reference-link
    (if (equal? source current-source)
        `(a ([href ,(format "#~a" id)]) "Cross reference")
        `(a ([href ,(format "/lesson/~a#~a" source id)]
             [hx-get ,(format "/lesson/~a#~a" source id)]
             [hx-target "#main"]
             [hx-push-url "true"]
             ;  [hx-on::after-swap
             ;   ,(format "document.getElementById('#~a').scrollIntoView({behavior: 'smooth'})" id)]
             [@click "activePage = '/lesson/page1'"]
             [:class "{ 'active': activePage === '/lesson/page1' }"])
            "Cross reference")))

  (@ reference-link `(div [(id ,id)])))
