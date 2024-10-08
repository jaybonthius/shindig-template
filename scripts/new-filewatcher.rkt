#lang racket

(require file-watchers)

(define (log-event event)
  (match event
    [(list 'robust 'add path)    (printf "New file: ~a~n" path)]
    [(list 'robust 'change path) (printf "Changed file: ~a~n" path)]
    [(list 'robust 'remove path) (printf "Deleted file: ~a~n" path)]
    [_ (void)]))

(define watcher-thread
  (watch (list (current-directory))
         log-event
         void
         (λ (path) (robust-watch path #:batch? #f))))

(printf "Watching directory: ~a~n" (current-directory))
(printf "Press Ctrl+C to stop...~n")

(with-handlers ([exn:break? (λ (e) (printf "Stopping watcher...~n"))])
  (sync watcher-thread))