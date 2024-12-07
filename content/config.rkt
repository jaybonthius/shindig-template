#lang racket

(provide pagetree)

(define pagetree
  '(pagetree index
             (frontmatter acknowledgements)
             (chapter (understanding-the-derivative index how-do-we-measure-velocity))
             (backmatter book-idx)))
