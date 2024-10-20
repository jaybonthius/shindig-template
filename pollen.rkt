#lang racket/base

(require "pollen-src/decode.rkt")
(require "pollen-src/questions.rkt")
(require "pollen-src/free-response.rkt")
(require "pollen-src/media.rkt")
(require "pollen-src/tags.rkt")
(require "pollen-src/utils.rkt")
(require "pollen-src/math.rkt")
(require "pollen-src/cross-references.rkt")

(provide (all-from-out "pollen-src/decode.rkt"))
(provide (all-from-out "pollen-src/questions.rkt"))
(provide (all-from-out "pollen-src/free-response.rkt"))
(provide (all-from-out "pollen-src/media.rkt"))
(provide (all-from-out "pollen-src/tags.rkt"))
(provide (all-from-out "pollen-src/utils.rkt"))
(provide (all-from-out "pollen-src/math.rkt"))
(provide (all-from-out "pollen-src/cross-references.rkt"))
(provide (all-defined-out))

(module setup racket/base
  (require racket/string)
  (provide (all-defined-out))
  (define command-char #\◊)
  (define block-tags '()) ; no block tags so that we can manually control them
  (define poly-targets '(html slide.html pdf))
  (define publish-directory (build-path (current-directory) 'up "pollen_out")))
