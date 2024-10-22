#lang racket/base

(require db
         koyo/haml
         racket/file
         racket/path
         (prefix-in config: "../config.rkt"))

(define (try-create-empty-file path)
  (with-handlers ([exn:fail? (lambda (e)
                               (printf "Error creating empty file: ~a\n" (exn-message e))
                               (void)
                               #f)])
    (call-with-output-file path (lambda (_) (void)))
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

(define (create-db sqlite-filepath sql-string)
  (define new-file-created (try-create-empty-file sqlite-filepath))

  (define conn (try-connect sqlite-filepath))
  (when new-file-created
    (with-handlers ([exn:fail? (lambda (e)
                                 (printf "Error during database operations: ~a\n" (exn-message e)))])

      (query-exec conn sql-string)

      (disconnect conn)

      (printf "Table created successfully.\n"))))

(define free-response-submissions-sqlite-filepath
  (build-path config:sqlite-path "free-response-submissions.sqlite"))
(define free-response-submissions-sql-string
  "CREATE TABLE IF NOT EXISTS free_response_submissions (
                  field_id TEXT NOT NULL,
                  user_id TEXT NOT NULL,
                  question_id TEXT,
                  submission TEXT,
                  is_correct INT,
                  PRIMARY KEY (field_id, user_id)
              )")

; TODO: only do this if config:backend (or whatever) is enabled
(create-db free-response-submissions-sqlite-filepath free-response-submissions-sql-string)

(define free-response-questions-sqlite-filepath
  (build-path config:sqlite-path "free-response-questions.sqlite"))
(define free-response-questions-sql-string
  "CREATE TABLE IF NOT EXISTS free_response_questions (
                field_id TEXT PRIMARY KEY NOT NULL,
                question_id TEXT NOT NULL,
                answer TEXT
              )")

(create-db free-response-questions-sqlite-filepath free-response-questions-sql-string)

(define cross-references-sqlite-filepatch (build-path config:sqlite-path "cross-references.sqlite"))
(define cross-references-sql-string
  "CREATE TABLE IF NOT EXISTS cross_references (
                  type TEXT NOT NULL,
                  id TEXT NOT NULL,
                  title TEXT NOT NULL,
                  source TEXT NOT NULL,
                  PRIMARY KEY (type, id)
              )")

(create-db cross-references-sqlite-filepatch cross-references-sql-string)
