#lang racket/base

(require db
         koyo/haml
         racket/file
         racket/path)

(define (try-create-empty-file path)
  (with-handlers ([exn:fail? (lambda (e)
                               (printf "Error creating empty file: ~a\n" (exn-message e))
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

(define current-dir (current-directory))
(define db-file (build-path current-dir "free-response-submissions.sqlite"))

(define new-file-created (try-create-empty-file db-file))

(define conn (try-connect db-file))
(when new-file-created
  (with-handlers ([exn:fail? (lambda (e)
                               (printf "Error during database operations: ~a\n" (exn-message e)))])

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

    (disconnect conn)

    (printf "Table created successfully.\n")))
