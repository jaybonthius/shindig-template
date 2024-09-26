#lang racket
(require rackunit)
(require "raw.rkt")

;; Define variables to use in tests
(define bar "Baz")
(define x 10)
(define y 20)
(define z '(1 2 3))

;; Test 1: Simple list with strings
(test-case "Simple list with strings"
(check-equal? (raw `(list "Foo" "Bar"))
                "@(list \"Foo\" \"Bar\")"))

;; Test 2: List with unquoted variable
(test-case "List with unquoted variable"
(check-equal? (raw `(list "Foo" ,bar))
                "@(list \"Foo\" \"Baz\")"))

;; Test 3: List with numbers and expressions
(test-case "List with numbers and expressions"
(check-equal? (raw `(list ,x ,y ,(+ x y)))
                "@(list 10 20 30)"))

;; Test 4: Nested cons with unquote
(test-case "Nested cons with unquote"
(check-equal? (raw `(cons "A" (cons ,bar '("C"))))
                "@(cons \"A\" (cons \"Baz\" (\"C\")))"))

;; Test 5: Lambda expression
(test-case "Lambda expression"
(check-equal? (raw `(lambda (x) (display x)))
                "@(lambda (x) (display x))"))

;; Test 6: Unquoted list variable
(test-case "Unquoted list variable"
(check-equal? (raw `,z)
                "@(1 2 3)"))

;; Test 7: If expression with variables
(test-case "If expression with variables"
(check-equal? (raw `(if (> ,x ,y) "x is greater" "y is greater"))
                "@(if (> 10 20) \"x is greater\" \"y is greater\")"))

;; Test 8: Define expression with unquoted variable name
(test-case "Define expression with unquoted variable name"
(check-equal? (raw `(define ,bar ,x))
                "@(define \"Baz\" 10)"))

;; Test 9: Single string
(test-case "Single string"
(check-equal? (raw `"Hello, World!")
                "@\"Hello, World!\""))

;; Test 10: Simple addition expression
(test-case "Simple addition expression"
(check-equal? (raw `(+ ,x ,y))
                "@(+ 10 20)"))