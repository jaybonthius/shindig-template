#lang racket/base

(require db
         pollen/core
         racket/port
         racket/string
         sugar
         (prefix-in config: "config.rkt")
         "utils.rkt")

(provide (all-defined-out))

(define (get-xref-source-and-title type id)
  (define db-connection
    (sqlite3-connect #:database (build-path (config:sqlite-path) "cross-references.sqlite")))

  (define result
    (query-maybe-row db-connection
                     "SELECT source, title FROM cross_references WHERE type = $1 AND id = $2"
                     (symbol->string type)
                     id))

  (if result
      (values (vector-ref result 0) (vector-ref result 1))
      (values #f #f)))

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
     (define type-id (format "~a-~a" (symbol->string type) uid))
     (define-values (source title) (get-xref-source-and-title type type-id))
     (define current-source (remove-ext* (hash-ref (current-metas) 'here-path)))
     (define reference-class (format "~a-preview" type-id))
     (define reference-container-class (format "~a-preview-container" type-id))
     ;  TODO: don't hardcode "lesson"
     (define reference-link
       (if (equal? source current-source)
           `(a [(href ,(format "#~a" type-id))] "View in context")
           `(a [(href ,(format "~alesson/~a#~a" (config:baseurl) source type-id))
                (hx-get ,(format "~alesson/~a#~a" (config:baseurl) source type-id))
                (hx-target "#main")
                (hx-select "#main")
                (hx-push-url "true")
                (@click ,(format "activePage = '~alesson/~a'" (config:baseurl) current-source))
                (:class ,(format "{ 'active': activePage === '~alesson/~a' }" (config:baseurl) current-source))]
               "View in context")))

     (@
      `(a
        [(class "decoration-dashed cursor-pointer")
         (script
          ,(format
            "on click get the next .~a toggle .expanded on it on htmx:afterRequest add .htmx-added to the next .~a"
            reference-container-class
            reference-container-class))
         (hx-get ,(format "~a~a/~a" (config:baseurl) (symbol->string type) uid))
         (hx-target ,(format "next .~a" reference-class))
         (hx-trigger "click once")
         (preload "mouseover")]
        ,title)
      `(div [(class ,(format "reference-container ~a" reference-container-class))]
            (div (div [(class "prose-md p-3")]
                      (div [(class ,(format "~a" reference-class))])
                      ,reference-link))))]))
