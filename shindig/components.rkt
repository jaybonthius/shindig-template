#lang racket/base

(require pollen/core
         pollen/tag
         racket/path
         sugar
         (prefix-in config: "../config.rkt")
         "utils.rkt")

(provide (all-defined-out))

(define (default-placeholder type uid)
  (default-tag-function 'div
                        #:hx-get (format "/~a/~a" (symbol->string type) uid)
                        #:hx-trigger "load"
                        #:hx-target "this"
                        #:hx-swap "outerHTML"))

(define ((make-component-function type tailwind) #:title title #:uid [uid ""] . body)
  (set! uid
        (if (string=? uid "")
            (to-kebab-case title)
            uid))
  (define id (format "~a-~a" (symbol->string type) uid))
  (define component
    `(div [(class "block")]
          (strong ,(if (eq? type 'definition)
                       title
                       (apply string-append
                              (list (string-titlecase (symbol->string type)) ": " title))))
          (div ,@body)))
  (define placeholder (default-placeholder type id))

  (define source (remove-ext* (file-name-from-path (hash-ref (current-metas) 'here-path))))
  (when (eq? type 'theorem)
    (printf (format "Source: ~a\n" source)))

  (upsert-xref type id title source)
  `(div ((id ,id) (class ,(format "px-6 py-0 mx-0 my-6 ~a" tailwind))
                  (component-type ,(symbol->string type))
                  (component-id ,uid))
        ,component))

(define (theorem-tailwind color)
  (format
   "border-l-2 border-~a-600 bg-[linear-gradient(to_right,var(--tw-gradient-stops))] from-~a-200 from-[length:0_1%] to-transparent to-[length:1%_100%]"
   color
   color))

(define theorem (make-component-function 'theorem (theorem-tailwind "pink")))
(define definition (make-component-function 'definition (theorem-tailwind "blue")))
(define lemma (make-component-function 'lemma (theorem-tailwind "purple")))
