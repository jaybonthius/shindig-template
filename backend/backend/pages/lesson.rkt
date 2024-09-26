#lang racket/base

(require koyo/haml
         racket/contract/base
         (for-syntax racket/base) ; to make command char work
         web-server/http
         web-server/servlet
         web-server/templates
         xml
         "../components/template.rkt")

(provide (contract-out [lesson-page (-> request? string? response?)]))

(define (lesson-page _req lesson-name)

  (displayln "Starting REPL...")

  (define (fast-template thing)
    (include-template #:command-char #\● "../../static.html"))

  (response/output (λ (op) (display (fast-template lesson-name) op))))
