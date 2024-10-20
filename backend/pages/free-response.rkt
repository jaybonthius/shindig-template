#lang racket/base

(require racket/contract/base
         (for-syntax racket/base) ; to make command char work
         web-server/servlet
         web-server/templates
         backend/components/user
         web-server/http/request-structs
         racket/match
         net/uri-codec
         (only-in srfi/13 string-index)
         (only-in net/http-easy post response-status-code response-body response-close!)
         db
         xml
         (prefix-in common-config: "../../common/config.rkt")
         "../components/auth.rkt")

(provide (contract-out [get-free-response-field (-> request? string? response?)]
                       [post-free-response-field (-> request? string? response?)]
                       [get-free-response-container (-> request? string? response?)]
                       [get-definition (-> request? string? response?)]))

(define (try-connect db-path)
  (with-handlers ([exn:fail? (lambda (e)
                               (printf "Error connecting to database: ~a\n" (exn-message e))
                               #f)])
    (printf "Attempting to connect to the database at: ~a\n" db-path)
    (define conn (sqlite3-connect #:database db-path))
    (printf "Successfully connected to the database.\n")
    conn))

(define (upsert-free-response-submission field-id user-id question-id submission is-corrent)
  (define db-file (build-path common-config:sqlite-path "free-response-submissions.sqlite"))

  ; convert is-correct from bool to int
  (define is-corrent-int (if is-corrent 1 0))

  (define conn (try-connect db-file))
  (when conn
    (with-handlers ([exn:fail? (lambda (e)
                                 (printf "Error during database operations: ~a\n" (exn-message e)))])
      ; todo: have this be a separate thing upon local setup
      (query-exec
       conn
       "CREATE TABLE IF NOT EXISTS free_response_submissions (
                field_id TEXT NOT NULL,
                user_id TEXT NOT NULL,
                question_id TEXT,
                submission TEXT,
                is_correct INT,
                PRIMARY KEY (field_id, user_id)
            )")

      (query-exec
       conn
       "INSERT OR REPLACE INTO free_response_submissions (field_id, user_id, question_id, submission, is_correct)
                   VALUES (?, ?, ?, ?, ?)"
       field-id
       user-id
       question-id
       submission
       is-corrent-int)

      (disconnect conn)
      )))

(define (custom-template path . args)
  (for ([i (in-range 0 (length args) 2)]
        #:when (< (+ i 1) (length args)))
    (namespace-set-variable-value! (list-ref args i) (list-ref args (+ i 1))))
  (eval #`(include-template #:command-char #\● #,path)))

(define (get-definition req uid)
  (get-component 'definition req uid))

(define (get-component type req uid)
  (define file-path (format "content/~a/~a.html" (symbol->string type) uid))
  (response/output (λ (op) (display (custom-template file-path) op))))

(define (get-free-response-container req question-id)
  (define file-path (format "content/free-response/~a.html" question-id))
  (response/output (λ (op) (display (custom-template file-path) op))))

(define (get-free-response-field req uid)
  (define current-user-info (current-user))
  (define username (user-username current-user-info))
  (define db-file (build-path common-config:sqlite-path "free-response-submissions.sqlite"))
  (define db-connection (sqlite3-connect #:database db-file))
  (define result
    (query-maybe-row
     db-connection
     "select submission, is_correct from free_response_submissions where field_id = $1 and user_id = $2"
     uid
     username))
  (match-define (vector latest-submission is-correct)
    (if result
        result
        (vector "" 0)))

  (set! is-correct (equal? is-correct 1))

  (define no-submission-style " {}")
  (define is-correct-style
    " {outline:4px solid #98C379;border-radius:4px;background:rgba(152, 195, 121, 0.11);}")

  (define is-not-correct-style
    " {outline:4px solid #d7170b;border-radius:4px;background:rgba(251, 187, 182, 0.1);}")

  (define field-uid (string-append "fr-field-" uid))
  (define field-style-uid (string-append "fr-style-" uid))

  (define style-content
    (cond
      [(equal? latest-submission "") no-submission-style]
      [is-correct is-correct-style]
      [else is-not-correct-style]))

  (define style `(style [(id ,field-style-uid)] ,(string-append "#" field-uid style-content)))

  (define math-field `(math-field [(id ,field-uid)] ,latest-submission))

  (define response-full-input
    (list (string->bytes/utf-8 (string-append (xexpr->string math-field) (xexpr->string style)))))

  (response/full 200 ; HTTP status code
                 #"OK" ; Status message
                 (current-seconds) ; Timestamp
                 #"text/plain" ; MIME type (plain text)
                 '() ; Additional headers
                 response-full-input))

(define (string-bool->racket-bool str-value)
  (cond
    [(equal? str-value "true") #t]
    [(equal? str-value "false") #f]
    [else (error "Invalid boolean string")]))

(define (post-free-response-field req uid)
  (define post-data (uri-decode (bytes->string/utf-8 (request-post-data/raw req))))
  (define (extract-submission s)
    (define pos (string-index s #\=))
    (if pos
        (substring s (+ pos 1))
        ""))
  (define submission (extract-submission post-data))
  (define alerts-id (string-append "fr-alerts-" uid))
  (define field-style-id (string-append "fr-style-" uid))

  (cond
    [(string=? submission "")
     (define style-tag `(style [(id ,field-style-id)] ""))
     (define alerts-tag
       `(div [(id ,alerts-id)]
             (div [(role "alert") (class "alert alert-error")] "Your submission cannot be empty.")))
     (response/full 200
                    #"OK"
                    (current-seconds)
                    #"text/plain"
                    '()
                    (list (string->bytes/utf-8 (string-append (xexpr->string style-tag)
                                                              (xexpr->string alerts-tag)))))]
    [else (process-submission uid submission)]))

(define (process-submission uid submission)
  (define current-user-info (current-user))
  (define username (user-username current-user-info))
  (define field-uid (string-append "fr-field-" uid))
  (define field-alerts-id (string-append "fr-alerts-" uid))
  (define field-style-id (string-append "fr-style-" uid))
  (define url "http://localhost:5200/compare")

  (define db-connection
    (sqlite3-connect #:database (build-path common-config:sqlite-path
                                            "free-response-questions.sqlite")))
  (define is-corrent
    (let* ([correct-answer-latex
            (query-value db-connection
                         "select answer from free_response_questions where field_id = $1"
                         uid)]
           [correct-answer-latex (regexp-replace* #px"([$#%&])" correct-answer-latex "\\\\\\1")]
           [payload (hash 'latex1 correct-answer-latex 'latex2 submission)]
           [response (post url #:json payload)])

      (response-close! response)

      (string-bool->racket-bool (bytes->string/utf-8 (response-body response)))))

  ; TODO: pass question-id
  (upsert-free-response-submission uid username "" submission is-corrent)

  (define (correct-style-tag uid)
    (string-append (string-append "#" uid " {")
                   "outline:4px solid #98C379;border-radius:4px;background:rgba(152, 195, 121, 0.11);"
                   "}"))

  (define (incorrect-style-tag uid)
    (string-append (string-append "#" uid " {")
                   "outline:4px solid #d7170b;border-radius:4px;background:rgba(251, 187, 182, 0.1);"
                   "}"))

  (define style-tag
    `(style [(id ,field-style-id)]
            ,(if is-corrent
                 (correct-style-tag field-uid)
                 (incorrect-style-tag field-uid))))

  (define response-full-input
    (list (string->bytes/utf-8 (string-append (xexpr->string style-tag)
                                              (xexpr->string `(div [(id ,field-alerts-id)] ""))))))

  (response/full 200 ; HTTP status code
                 #"OK" ; Status message
                 (current-seconds) ; Timestamp
                 #"text/plain" ; MIME type (plain text)
                 '() ; Additional headers
                 response-full-input))
