#lang racket/base

(require koyo/haml
         racket/contract/base
         (for-syntax racket/base) ; to make command char work
         web-server/http
         web-server/servlet
         web-server/templates
         racket/path
         racket/runtime-path
         racket/pretty
         xml
         (prefix-in config: "../config.rkt")
         "../components/template.rkt")

(provide (contract-out [lesson-page (-> request? string? response?)]
                       [index-page (-> request? response?)]))

(define (index-page _req)
  (define (dynamic-include-template lesson-content)
    (include-template #:command-char #\● "../../pollen/base.html"))
  (response/output (λ (op) (display (dynamic-include-template "hello!") op))))

(define (hx-request? request)
  (define headers (request-headers request))
  (define hx-request-header (assoc 'hx-request headers))
  (and hx-request-header (equal? (cdr hx-request-header) "true")))

(define (lesson-page _req lesson-name)

  (define is-hx-request (hx-request? _req))
  
  (displayln (format "Received ~a-request for ~a" (if is-hx-request "HX" "non-HX") lesson-name))

  (define (dynamic-include-template path)
    (eval #`(include-template #:command-char #\● #,path)))

  (define (include-base-template lesson-content)
    (include-template #:command-char #\● "../../pollen/base.html"))

  (define file-path (format "pollen/~a.html" lesson-name))
  (define base-path "pollen/base.html")

  (define rendered-page (response/output (λ (op) (display (dynamic-include-template file-path) op))))
  (define (get-response-content response)
    (let ([output (open-output-string)])
      ((response-output response) output)
      (get-output-string output)))
  (define lesson-content (get-response-content rendered-page))

  (if is-hx-request
      rendered-page
      (response/output 
       (λ (op) 
         (display (include-base-template lesson-content) op)))))
