#lang racket/base

(require db
         racket/file
         racket/path
         (prefix-in config: "../shindig/config.rkt"))

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

(define cross-references-sqlite-filepath (build-path "content" "sqlite" "cross-references.sqlite"))
(define cross-references-sql-string
  "CREATE TABLE IF NOT EXISTS cross_references (
                  type TEXT NOT NULL,
                  id TEXT NOT NULL,
                  title TEXT NOT NULL,
                  source TEXT NOT NULL,
                  PRIMARY KEY (type, id)
              )")

(define book-index-sqlite-filepath (build-path "content" "sqlite" "book-index.sqlite"))
(define book-index-sql-string
  "CREATE TABLE IF NOT EXISTS book_index (
                  id TEXT NOT NULL,
                  source TEXT NOT NULL,
                  entry TEXT NOT NULL,
                  subentry TEXT NOT NULL,
                  PRIMARY KEY (id, source)
              )")

(create-db cross-references-sqlite-filepath cross-references-sql-string)
(create-db book-index-sqlite-filepath book-index-sql-string)
