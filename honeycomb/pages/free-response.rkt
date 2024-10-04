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
         racket/port
         net/uri-codec
         (only-in net/http-easy post response-status-code response-body response-close!)
         racket/string
         json
         db
         xml
         (prefix-in config: "../config.rkt")
         "../components/template.rkt")

(provide (contract-out [get-free-response (-> request? string? response?)]
                       [post-free-response (-> request? string? response?)]))

(define (free-response-template path . args)
  (for ([i (in-range 0 (length args) 2)])
    (when (< (+ i 1) (length args))
      (namespace-set-variable-value! (list-ref args i) (list-ref args (+ i 1)))))
  (eval #`(include-template #:command-char #\● #,path)))

(define (extract-value data key)
  (define pattern (string-append key "=([^&]+)"))
  (define match (regexp-match pattern data))
  (if match (cadr match) #f))

(define (get-free-response req uid)
  (render-free-response req uid))

(define (render-free-response #:results [results (hash)] req uid)
  (define file-path (format "pollen/free-response/~a.html" uid))

  (define (rendered-page-with-div #:prepend-content [prepend-content ""]
                                  #:append-content [append-content ""]
                                  file-path)
    (define rendered-content
      (call-with-output-string (lambda (op) (display (free-response-template file-path) op))))

    (define modified-content (string-append prepend-content rendered-content append-content))

    (response/output (lambda (op) (display modified-content op))))

  ; TODO: check if student answer is in DB

  (pretty-print results)

  (define (correct-style-tag uid)
    (string-append "<style>"
                   (string-append "#" uid " {")
                   "outline:4px solid #98C379;border-radius:4px;background:rgba(152, 195, 121, 0.11);"
                   "}"
                   "</style>"))

  (define (incorrect-style-tag uid)
    (string-append "<style>"
                   (string-append "#" uid " {")
                   "outline:4px solid #d7170b;border-radius:4px;background:rgba(251, 187, 182, 0.1);"
                   "}"
                   "</style>"))

  (define style-tags '())
  (for ([result results])
    (if (hash-ref result 'is-correct)
        (set! style-tags (cons (correct-style-tag (hash-ref result 'uid)) style-tags))
        (set! style-tags (cons (incorrect-style-tag (hash-ref result 'uid)) style-tags))))

  (pretty-print style-tags)
  (set! style-tags (string-join style-tags ""))

  (define rendered-page (rendered-page-with-div #:append-content style-tags file-path))

  rendered-page)

(define (bytes-string->string value)
  (if (bytes? value) (bytes->string/utf-8 value) value))

(define (string-bool->racket-bool str-value)
  (cond
    [(equal? str-value "true") #t]
    [(equal? str-value "false") #f]
    [else (error "Invalid boolean string")]))

(define (post-free-response req uid)
  (define post-data (uri-decode (bytes->string/utf-8 (request-post-data/raw req))))
  (define (parse-http-request-string str)
    (define (parse-pair pair)
      (let* ([key-value (string-split pair "=")]
             [key (first key-value)]
             [value (string-join (rest key-value) "=")])
        (cons key (if (string-prefix? value "{") (string->jsexpr value) value))))

    (define (parse-submission submission)
      (if (and (hash? submission) (hash-has-key? submission 'uid)) (hash-ref submission 'uid) #f))

    (let* ([pairs (string-split str "&")]
           [parsed-pairs (map parse-pair pairs)]
           [submissions (filter-map (lambda (pair) (and (equal? (car pair) "submissions") (cdr pair)))
                                    parsed-pairs)])
      submissions))
  (define submissions (parse-http-request-string post-data))

  ; check if submissions are correct
  (define url "http://localhost:5200/compare")
  (define db-connection (sqlite3-connect #:database "pollen/questions.sqlite"))

  (define (process-submission submission)
    (let* ([uid (hash-ref submission 'uid)]
           [submission-latex (hash-ref submission 'latex)]
           [correct-answer-latex
            (string->jsexpr
             (query-value db-connection "select answer from questions where id = $1" uid))]
           [correct-answer-latex (regexp-replace* #px"([$#%&])" correct-answer-latex "\\\\\\1")]
           [payload (hash 'latex1 correct-answer-latex 'latex2 submission-latex)]
           [response (post url #:json payload)]
           [is-correct (string-bool->racket-bool (bytes->string/utf-8 (response-body response)))])

      (response-close! response)

      (hash 'uid
            uid
            'latex
            submission-latex
            'correct-answer-latex
            correct-answer-latex
            'is-correct
            is-correct)))

  (define processed-submissions (map process-submission submissions))

  ; TODO: add to student DB

  (render-free-response #:results processed-submissions req uid))
