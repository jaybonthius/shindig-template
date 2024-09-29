#lang racket/base

(require koyo/haml
         racket/contract/base
         (for-syntax racket/base) ; to make command char work
         web-server/http
         web-server/servlet
         web-server/templates
         web-server/http/request-structs
         racket/path
         racket/runtime-path
         racket/pretty
         racket/set
         racket/list
         racket/string
         json
         db
         xml
         (prefix-in config: "../config.rkt")
         "../components/template.rkt")

(provide (contract-out [lesson-page (-> request? string? response?)]
                       [index-page (-> request? response?)]
                       [question-detail (-> request? string? response?)]))

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
      (response/output (λ (op) (display (include-base-template lesson-content) op)))))

(define (question-detail req question-id)
  (define is-post-request (equal? (request-method req) #"POST"))

  (define-values (correct-answers selected-answers)
    (if is-post-request
        (process-post-request req question-id)
        (values null null)))

  (define file-path (format "pollen/question/~a.html" question-id))
  (define rendered-page
    (response/output
     (λ (op) (display (question-template file-path 'correct-answers correct-answers 'selected-answers selected-answers) op))))

  rendered-page)

(define (process-post-request req question-id)
  (define selected-answers
    (let* ([body (bytes->string/utf-8 (request-post-data/raw req))]
           [answers (list->set (map (lambda (pair) (cadr (string-split pair "=")))
                                    (string-split body "&")))])
      answers))

  (define db-connection (sqlite3-connect #:database "pollen/questions.sqlite"))
  (define correct-answers 
    (list->set (string->jsexpr 
                (query-value db-connection 
                             "select answer from questions where id = $1" 
                             question-id))))

  (values correct-answers selected-answers))

(define (question-template path . args)
  (for ([i (in-range 0 (length args) 2)])
    (when (< (+ i 1) (length args))
      (namespace-set-variable-value! (list-ref args i) (list-ref args (+ i 1)))))
  (eval #`(include-template #:command-char #\● #,path)))
