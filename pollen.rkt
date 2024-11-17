#lang racket/base

(require net/url
         racket/path
         racket/runtime-path
         racket/string
         reprovide/reprovide
         reprovide/require-transformer/glob-in)

(reprovide shindig)

(provide (all-defined-out))

(putenv "PROJECT_DIR" "/home/jay/Code/honeycomb/content")

(define (remove-baseurl url-str)
  (with-handlers ([exn:fail? (λ (e) url-str)])
    (define url-obj (string->url url-str))
    (cond
      [(url? url-obj)
       (define scheme (url-scheme url-obj))
       (define host (url-host url-obj))
       (cond
         [(and scheme host)
          (define base-length (+ (string-length scheme) (string-length "://") (string-length host)))
          (substring url-str base-length)]
         [else url-str])]
      [else url-str])))

(baseurl (remove-baseurl (or (getenv "BASE_URL") "/")))
(pretty-url (or (string->boolean (getenv "PRETTY_URL")) #f))

(module setup racket/base
  (require racket/string)
  (provide (all-defined-out))
  (define command-char #\◊)
  (define block-tags '()) ; no block tags so that we can manually control them
  (define poly-targets '(html pdf tex))
  (define publish-directory (build-path (current-directory) 'up "pollen_out")))

(define (pdfable? file-path)
  (string-contains? file-path ".poly"))
