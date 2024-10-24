#lang racket/base

(require reprovide/reprovide
         reprovide/require-transformer/glob-in
         racket/runtime-path
         racket/string)

(reprovide shindig)

(provide (all-defined-out))

(baseurl (string-replace (or (getenv "BASE_URL") "/") "http://" "https://"))

(module setup racket/base
  (require racket/string)
  (provide (all-defined-out))
  (define command-char #\◊)
  (define block-tags '()) ; no block tags so that we can manually control them
  (define poly-targets '(html slide.html pdf))
  (define publish-directory (build-path (current-directory) 'up "pollen_out")))
