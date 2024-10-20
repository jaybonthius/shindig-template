#lang racket/base

(require pollen/setup)

(provide (all-defined-out))

(define project-root (string->path "/home/jay/Code/honeycomb/"))

(define pollen-dir (build-path project-root "content"))

(define sqlite-path (build-path project-root "sqlite"))
