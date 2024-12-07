#lang racket

(provide (all-defined-out))

(define pagetree
  '(pagetree (frontmatter acknowledgements)
             (chapter (understanding-the-derivative index how-do-we-measure-velocity))
             (backmatter book-idx)))

(define book-title "Active Calculus")
(define author "Jay Bonthius")
