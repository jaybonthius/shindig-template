#lang racket/base

(require "rkt/decode.rkt")
(require "rkt/markup/questions.rkt")
(require "rkt/markup/free-response.rkt")
(require "rkt/markup/media.rkt")
(require "rkt/markup/tags.rkt")
(require "rkt/utils.rkt")
(require "rkt/markup/math.rkt")
(require "rkt/markup/cross-references.rkt")

(provide (all-from-out "rkt/decode.rkt"))
(provide (all-from-out "rkt/markup/questions.rkt"))
(provide (all-from-out "rkt/markup/free-response.rkt"))
(provide (all-from-out "rkt/markup/media.rkt"))
(provide (all-from-out "rkt/markup/tags.rkt"))
(provide (all-from-out "rkt/utils.rkt"))
(provide (all-from-out "rkt/markup/math.rkt"))
(provide (all-from-out "rkt/markup/cross-references.rkt"))
(provide (all-defined-out))

(module setup racket/base
  (require racket/string)
  (provide (all-defined-out))
  (define command-char #\◊)
  (define block-tags '()) ; no block tags so that we can manually control them
  (define poly-targets '(html slide.html pdf))
  (define publish-directory (build-path (current-directory) 'up "pollen_out")))
