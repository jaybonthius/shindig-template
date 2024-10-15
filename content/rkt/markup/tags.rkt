#lang racket/base

(require db
         pollen/core
         pollen/render
         pollen/setup
         pollen/tag
         racket/file
         racket/match
         racket/path
         racket/port
         racket/string
         (prefix-in config: "../../../common/config.rkt")
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
  (define temp-rkt-path (build-path temp-dir (string-append uid ".rkt")))
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

  (with-output-to-file temp-rkt-path
                       (lambda ()
                         (displayln "#lang racket/base")
                         (display "`")
                         (write xexpr))
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
  (define component `(div [(class "block")] (strong ,name) (div ,@body)))
  (define placeholder (default-placeholder type id))

  (define source (filename-without-extension (hash-ref (current-metas) 'here-path)))

  (upsert-xref type id source)
  (render-component component type id)
  ; (if load-asynchronously? placeholder component)
  `(div ((id ,id)) ,component))

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

(define (extract-pollen-content str)
  (define prefix "#lang racket/base\n`")
  (define prefix-length (string-length prefix))
  (unless (string-prefix? str prefix)
    (error "Input string does not start with the expected prefix"))
  (string->xexpr (substring str prefix-length)))

(define (string->xexpr str)
  (with-input-from-string str (lambda () (read))))

(define (ref #:type type #:uid uid)
  (define generate-references (equal? (getenv "POLLEN") "generate-xrefs"))
  (cond
    [generate-references `(button [(class "btn")] "References have not been generated yet!!")]
    [else
     (define id (format "~a-~a" (symbol->string type) uid))
     (define source (get-xref-source type id))
     (define current-source (filename-without-extension (hash-ref (current-metas) 'here-path)))

     (define ref-name (string-append (string-titlecase (symbol->string type)) " " uid))

     (define reference-class (format "~a-preview" id))
     (define reference-container-class (format "~a-preview-container" id))
     (define reference-link
       (if (equal? source current-source)
           `(a [(href ,(format "#~a" id))] "View in context")
           `(a [(href ,(format "/lesson/~a#~a" source id))
                (hx-get ,(format "/lesson/~a#~a" source id))
                (hx-target "#main")
                (hx-select "#main")
                (hx-push-url "true")
                (@click ,(format "activePage = '/lesson/~a'" current-source))
                (:class ,(format "{ 'active': activePage === '/lesson/~a' }" current-source))]
               "View in context")))
     (define reference-path
       (build-path config:pollen-dir (symbol->string type) "temp" (format "~a.rkt" id)))
     (define reference-content (extract-pollen-content (file->string reference-path)))

     (@
      `(a
        [(class "decoration-dashed cursor-pointer")
         (script
          ,(format
            "on click get the next .~a toggle .expanded on it on htmx:afterRequest add .htmx-added to the next .~a"
            reference-container-class
            reference-container-class))
         (hx-get ,(format "/get-~a/~a" (symbol->string type) id))
         (hx-target ,(format "next .~a" reference-class))
         (hx-trigger "click once")
         (preload "mouseover")]
        ,ref-name)
      `(div [(class ,(format "reference-container ~a" reference-container-class))]
            (div (div [(class "prose-md p-3")]
                      (div [(class ,(format "~a" reference-class))])
                      ,reference-link))))]))
