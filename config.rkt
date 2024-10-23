#lang racket/base

(require pollen/setup)

(provide (all-defined-out))

(define project-root "/home/jay/Code/honeycomb/") ; TODO: make this automatic
(define pollen-dir (build-path project-root "content"))
(define sqlite-path (build-path project-root "sqlite"))

(define honeycomb-debug #f)
(define honeycomb-log-level "debug")
(define honeycomb-profile "x")
(define database-url "postgresql://postgres:postgres@localhost:5432/postgres")
