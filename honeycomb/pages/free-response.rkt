#lang racket/base

(require koyo/haml
         racket/contract/base
         (for-syntax racket/base) ; to make command char work
         web-server/http
         web-server/servlet
         web-server/templates
         honeycomb/components/auth
         honeycomb/components/user
         web-server/http/request-structs
         racket/path
         racket/match
         racket/file
         racket/runtime-path
         racket/pretty
         racket/set
         racket/list
         racket/port
         net/uri-codec
         (only-in srfi/13 string-index)
         (only-in net/http-easy post response-status-code response-body response-close!)
         racket/string
         json
         db
         xml
         (prefix-in config: "../config.rkt")
         "../components/auth.rkt"
         "../components/template.rkt")

(provide (contract-out [get-free-response (-> request? string? response?)]
                       [post-free-response (-> request? string? response?)]))

(define (try-create-empty-file path)
  (with-handlers ([exn:fail? (lambda (e)
                               ;  (printf "Error creating empty file: ~a\n" (exn-message e))
                               (void)
                               #f)])
    (call-with-output-file path (lambda (out) (void)))
    (printf "Successfully created empty file.\n")
    #t))

(define (try-connect db-path)
  (with-handlers ([exn:fail? (lambda (e)
                               (printf "Error connecting to database: ~a\n" (exn-message e))
                               #f)])
    (printf "Attempting to connect to the database at: ~a\n" db-path)
    (define conn (sqlite3-connect #:database db-path))
    (printf "Successfully connected to the database.\n")
    conn))

(define (upsert-free-response-submission field-id user-id question-id submission is-corrent)
  (define current-dir (current-directory))
  (define db-file (build-path current-dir "free-response-submissions.sqlite"))
  ; todo: have this be a separate thing upon local setup
  (try-create-empty-file db-file)

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

      (printf "Database operations completed successfully.\n"))))

(define (get-free-response req uid)
  (displayln "GET /free-response")
  (define current-user-info (current-user))
  (define username (user-username current-user-info))
  (define db-connection (sqlite3-connect #:database "free-response-submissions.sqlite"))
  (match-define (vector latest-submission is-correct)
    (query-row
     db-connection
     "select submission, is_correct from free_response_submissions where field_id = $1 and user_id = $2"
     uid
     username))
  (set! is-correct (if (equal? is-correct 1) #t #f))

  (define is-correct-style
    " {outline:4px solid #98C379;border-radius:4px;background:rgba(152, 195, 121, 0.11);}")

  (define is-not-correct-style
    " {outline:4px solid #d7170b;border-radius:4px;background:rgba(251, 187, 182, 0.1);}")

  (define field-uid (string-append "fr-field-" uid))
  (define field-style-uid (string-append "fr-style-" uid))

  (define style
    `(style [(id ,field-style-uid)]
            ,(string-append "#" field-uid (if is-correct is-correct-style is-not-correct-style))))

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

(define (post-free-response req uid)
  (displayln "POST /free-response")
  (define field-uid (string-append "fr-field-" uid))
  (define current-user-info (current-user))
  (define username (user-username current-user-info))
  (define post-data (uri-decode (bytes->string/utf-8 (request-post-data/raw req))))

  (define (extract-submission s)
    (let ([pos (string-index s #\=)]) (if pos (substring s (+ pos 1)) "")))
  (define submission (extract-submission post-data))

  ; check if submissions are correct
  (define url "http://localhost:5200/compare")
  (define db-connection (sqlite3-connect #:database "pollen/free-response-questions.sqlite"))
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

  (define style-tag (if is-corrent (correct-style-tag field-uid) (incorrect-style-tag field-uid)))

  (response/xexpr style-tag))
