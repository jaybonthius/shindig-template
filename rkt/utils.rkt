#lang racket/base

(require racket/match
        db
         json
         pollen/decode
         pollen/render
         pollen/template
         racket/file
         racket/list
         racket/pretty
         racket/set
         racket/string
         "markup/sqlite.rkt"
         xml)

(provide (all-defined-out))

; for utilities

(define (validate-uid uid)
  (when (or (not (string? uid)) (string=? uid ""))
    (raise-argument-error 'fr-field "non-empty string" uid))
)

(define (quote-xexpr-attributes xexpr)
  (match xexpr
    [(list tag (and attrs (list (list _ _) ...)) content ...)
     (list* tag `'(,@attrs) (map quote-xexpr-attributes content))]
    [(list tag content ...) (cons tag (map quote-xexpr-attributes content))]
    [else xexpr]))

(define (render-x-expression xexpr prefix filename)
  (define output-dir (build-path (current-directory) prefix))
  (define temp-dir (build-path output-dir "temp"))
  (define temp-path (build-path temp-dir (string-append filename ".html.pm")))
  (define output-path (build-path output-dir (string-append filename ".html")))
  (define template-path (build-path output-dir (format "~a-template.html.p" prefix)))

  (make-directory* temp-dir)
  (make-directory* output-dir)

  (with-output-to-file temp-path
                       (lambda ()
                         (displayln "#lang pollen")
                         (display "☉")
                         (write xexpr))
                       #:exists 'replace)

  (render-to-file-if-needed temp-path template-path output-path)
  output-path)

(define (upsert-question question-id answers)
  (define current-dir (current-directory))
  (define db-file (build-path current-dir "questions.sqlite"))
  ; todo: have this be a separate thing upon local setup
  (try-create-empty-file db-file)

  (define conn (try-connect db-file))
  (when conn
    (with-handlers ([exn:fail? (lambda (e)
                                 (printf "Error during database operations: ~a\n" (exn-message e)))])
      ; todo: have this be a separate thing upon local setup
      (query-exec
       conn
       "CREATE TABLE IF NOT EXISTS questions (
                id TEXT PRIMARY KEY NOT NULL,
                answer JSON
            )")

      (define json-answers (jsexpr->string answers))

      (query-exec
       conn
       "INSERT OR REPLACE INTO questions (id, answer)
                   VALUES (?, json(?))"
       question-id
       json-answers)

      (disconnect conn)

      (printf "Database operations completed successfully.\n"))))