#lang racket

(require db)

(provide (all-defined-out))

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
    (let ([conn (sqlite3-connect #:database db-path)])
      (printf "Successfully connected to the database.\n")
      conn)))
