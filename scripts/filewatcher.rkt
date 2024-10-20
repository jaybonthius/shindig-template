#lang racket

(require file-watchers
         file/glob
         racket/string
         racket/system)

(define (path->basename path)
  (define-values (dir name _) (split-path path))
  (path->string name))

(define (path->dirname path)
  (define-values (dir name _) (split-path path))
  (path->string dir))

(define (string-replace-all str replacements)
  (foldl (λ (replacement acc) (string-replace acc (car replacement) (cdr replacement)))
         str
         replacements))

(define (replace-variables command path)
  (string-replace-all command
                      (list (cons "{filename}" (path->string path))
                            (cons "{basename}" (path->basename path))
                            (cons "{dirname}" (path->dirname path)))))

(define rules
  (hash
   '("**.rkt" (add change))
   (list "raco fmt -i {filename}" "echo 'Racket file reformatted {filename}'")
   '("rkt/**.rkt" (add change))
   (list "make reset" "make render" "echo 'Pollen files re-rendered'")
   '("**.html.p" (add change))
   (list "make render" "echo 'Pollen files re-rendered'")
   '("**.poly.pm" (add change))
   (list "raco pollen render {filename}" "echo 'Pollen file rendered {filename}'")
   '("**.tldr" (add change))
   (list "pnpm tldraw export {filename} --transparent --output {dirname}/light.svg"
         "pnpm tldraw export {filename} --transparent --output {dirname}/dark.svg --dark"
         "pnpm tldraw export {filename} --transparent --output {dirname}/light.png --format png"
         "pnpm tldraw export {filename} --transparent --output {dirname}/dark.png --format png --dark"
         "echo 'tldraw file rendered'")))

(define (find-matching-rules path event-type)
  (for/list ([(pattern+events commands) (in-hash rules)]
             #:when (and (glob-match? (car pattern+events) path)
                         (member event-type (cadr pattern+events))))
    commands))

(define (execute-commands commands path)
  (for ([command commands])
    (define formatted-command (replace-variables command path))
    (system formatted-command)))

(define (handle-event event)
  (match event
    [(list 'robust type path)
     (define matching-commands (find-matching-rules path type))
     (unless (null? matching-commands)
       (for-each (λ (commands) (execute-commands commands path)) matching-commands))]
    [_ (void)]))

(define watcher-thread
  (watch (list (current-directory)) handle-event void (λ (path) (robust-watch path #:batch? #f))))

(printf "Watching directory: ~a~n" (current-directory))
(printf "Press Ctrl+C to stop...~n")

(with-handlers ([exn:break? (λ (e) (printf "Stopping watcher...~n"))])
  (sync watcher-thread))
