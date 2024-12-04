#lang racket

(provide pagetree)

(define pagetree
  '(pagetree index
             (frontmatter acknowledgements foreword)
             (chapter (1-introduction index typography math knowl tldraw))))
