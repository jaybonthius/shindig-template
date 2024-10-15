#lang racket/base

(require racket/contract/base
         (for-syntax racket/base) ; to make command char work
         web-server/servlet
         web-server/templates
         web-server/http/request-structs
         racket/set
         (only-in net/http-easy post response-status-code response-body response-close!)
         racket/string
         json
         db)

(provide (contract-out [lesson-page (-> request? string? response?)]
                       [index-page (-> request? response?)]
                       [question-detail (-> request? string? response?)]))

(define (index-page _req)
  (define is-hx-request (hx-request? _req))

  (define (dynamic-include-template path)
    (eval #`(include-template #:command-char #\● #,path)))

  (define (include-base-template lesson-content)
    (include-template #:command-char #\● "../../content/base.html"))

  (define file-path "content/lesson/index.html")

  (define rendered-page (response/output (λ (op) (display (dynamic-include-template file-path) op))))
  (define (get-response-content response)
    (define output (open-output-string))
    ((response-output response) output)
    (get-output-string output))
  (define lesson-content (get-response-content rendered-page))

  (if is-hx-request
      rendered-page
      (response/output (λ (op) (display (include-base-template lesson-content) op)))))

(define (hx-request? request)
  (define headers (request-headers request))
  (define hx-request-header (assoc 'hx-request headers))
  (and hx-request-header (equal? (cdr hx-request-header) "true")))

(define (lesson-page _req lesson-name)

  (define is-hx-request (hx-request? _req))

  (define (dynamic-include-template path)
    (eval #`(include-template #:command-char #\● #,path)))

  (define (include-base-template lesson-content)
    (include-template #:command-char #\● "../../content/base.html"))

  (define file-path (format "content/lesson/~a.html" lesson-name))

  (define rendered-page (response/output (λ (op) (display (dynamic-include-template file-path) op))))
  (define (get-response-content response)
    (define output (open-output-string))
    ((response-output response) output)
    (get-output-string output))
  (define lesson-content (get-response-content rendered-page))

  (if is-hx-request
      rendered-page
      (response/output (λ (op) (display (include-base-template lesson-content) op)))))

(define (question-detail req question-id)
  (define is-post-request (equal? (request-method req) #"POST"))

  (define-values (correct-answers selected-answers)
    (if is-post-request (process-post-request req question-id) (values null null)))

  (define file-path (format "content/question/~a.html" question-id))
  (response/output (λ (op)
                     (display (question-template file-path
                                                 'correct-answers
                                                 correct-answers
                                                 'selected-answers
                                                 selected-answers)
                              op))))

(define (process-post-request req question-id)
  (define selected-answers
    (let* ([body (bytes->string/utf-8 (request-post-data/raw req))]
           [answers (list->set (map (lambda (pair) (cadr (string-split pair "=")))
                                    (string-split body "&")))])
      answers))

  (define db-connection (sqlite3-connect #:database "content/questions.sqlite"))
  (define correct-answers
    (list->set (string->jsexpr (query-value db-connection
                                            "select answer from questions where id = $1"
                                            question-id))))

  (values correct-answers selected-answers))

(define (question-template path . args)
  (for ([i (in-range 0 (length args) 2)]
        #:when (< (+ i 1) (length args)))
    (namespace-set-variable-value! (list-ref args i) (list-ref args (+ i 1))))
  (eval #`(include-template #:command-char #\● #,path)))

; (define (check-free-response req)
;   (define post-data (uri-decode (bytes->string/utf-8 (request-post-data/raw req))))

;   (define latex (extract-value post-data "latex"))
;   (define uuid (format "question-~a" (extract-value post-data "uuid")))

;   (define db-connection (sqlite3-connect #:database "content/questions.sqlite"))
;   (define correct-answer
;     (string->jsexpr (query-value db-connection "select answer from questions where id = $1" uuid)))
;   (define escaped-correct-answer (regexp-replace* #px"([$#%&])" correct-answer "\\\\\\1"))

;   (define url "http://localhost:5200/compare")
;   (define payload (hash 'latex1 escaped-correct-answer 'latex2 latex))
;   (define response (post url #:json payload))
;   (define is-correct (string-bool->racket-bool (bytes-string->string (response-body response))))

;   (displayln (format "Is correct?: ~a" is-correct))

;   (response-close! response)

;   (define css
;     (if (equal? is-correct #t)
;         `(style
;           ,(format "#~a {outline:4px solid #98C379;border-radius:4px;background:rgba(152, 195, 121, 0.11);}" uuid)
;         )
;         `(style
;           ,(format "#~a {outline:4px solid #d7170b;border-radius:4px;background:rgba(251, 187, 182, 0.1);}" uuid)
;         )
;     )
;   )

;   (define server-response
;     (if (equal? is-correct #t)
;         `(i ((class "fa-solid fa-circle-check text-green-500 text-xl")))
;         `(i ((class "fa-solid fa-circle-xmark text-red-500 text-xl")))
;     )
;   )

;   ; log the css we're sending
;   (displayln css)

;   (define rendered-page
;     (response/xexpr css
;     ))

;   rendered-page)

(define (extract-value data key)
  (define pattern (string-append key "=([^&]+)"))
  (define match (regexp-match pattern data))
  (and match (cadr match)))

; Function to convert byte string to regular string
(define (bytes-string->string value)
  (if (bytes? value) (bytes->string/utf-8 value) value))

; Function to convert string boolean to Racket boolean
(define (string-bool->racket-bool str-value)
  (cond
    [(equal? str-value "true") #t]
    [(equal? str-value "false") #f]
    [else (error "Invalid boolean string")]))
