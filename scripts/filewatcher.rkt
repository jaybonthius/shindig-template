#lang racket

(require file-watchers
         file/glob
         racket/list
         racket/path
         racket/string
         racket/system
         racket/async-channel)

(define (glob->paths pattern)
  (for/list ([p (in-directory ".")]
             #:when (glob-match? pattern (path->string p)))
    p))

(define (run-commands-for-file file-path commands)
  (for ([cmd commands])
    (define formatted-cmd (string-replace cmd "{filename}" (path->string file-path)))
    (displayln (string-append "Running command: " formatted-cmd))
    (system formatted-cmd)))

(define (watch-glob pattern commands)
  (let ([current-paths (glob->paths pattern)]
        [change-channel (make-async-channel)])
    (let loop ([paths current-paths])
      (watch paths (lambda (activity) (async-channel-put change-channel (caddr activity))))
      (let process-changes ()
        (define maybe-file-path (async-channel-try-get change-channel))
        (when maybe-file-path
          (when (glob-match? pattern (path->string maybe-file-path))
            (displayln (format "Change detected for ~a" (path->string maybe-file-path)))
            (run-commands-for-file maybe-file-path commands))
          (process-changes)))
      (sleep 1) ; Short sleep to prevent busy-waiting
      (define new-paths (glob->paths pattern))
      (when (not (equal? paths new-paths))
        (displayln (format "New files detected for pattern: ~a" pattern))
        (for ([new-path (set-subtract new-paths paths)])
          (displayln (format "New file: ~a" (path->string new-path)))
          (run-commands-for-file new-path commands)))
      (loop new-paths))))

(define glob-command-map
  #hash(("pollen/*.pm" . ("raco pollen render {filename}" "echo 'Pollen file {filename} updated'"))
        ("**/*.rkt" . ("raco fmt -i {filename}"))))

(define (start-watchers)
  (for ([(glob commands) (in-hash glob-command-map)])
    (thread (lambda () (watch-glob glob commands)))))

(start-watchers)
(sync never-evt)
