#lang racket/base

(require reprovide/reprovide
         reprovide/require-transformer/glob-in
         racket/runtime-path
         racket/string
         net/url)

(reprovide shindig)

(provide (all-defined-out))

(define (remove-baseurl url-str)
  (with-handlers ([exn:fail? (λ (e) url-str)])
    (let ([url-obj (string->url url-str)])
      (if (url? url-obj)
          (let ([scheme (url-scheme url-obj)]
                [host (url-host url-obj)])
            (if (and scheme host)
                (let ([base-length (+ (string-length scheme) 
                                    (string-length "://") 
                                    (string-length host))])
                  (substring url-str base-length))
                url-str))
          url-str))))

(baseurl (remove-baseurl (or (getenv "BASE_URL") "/")))

(module setup racket/base
  (require racket/string)
  (provide (all-defined-out))
  (define command-char #\◊)
  (define block-tags '()) ; no block tags so that we can manually control them
  (define poly-targets '(html slide.html pdf))
  (define publish-directory (build-path (current-directory) 'up "pollen_out")))
