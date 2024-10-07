#lang racket/base

(require pollen/decode
         racket/pretty
         txexpr)

(provide (all-defined-out))

(define (hyperlink-decoder inline-tx)
  (define (hyperlinker url . words)
    `(a [[href ,url]
         (class "align-text-bottom text-[#0077AA] no-underline hover:underline")]
        ,@words))

  (if (eq? 'hyperlink (get-tag inline-tx))
      (apply hyperlinker (get-elements inline-tx))
      inline-tx))

(define (root . elements)
  (define first-pass
    (decode-elements elements
                     #:txexpr-elements-proc decode-paragraphs
                     #:exclude-tags '(script style figure)))
  (define body
    (make-txexpr 'body
                 null
                 (decode-elements first-pass
                                  #:inline-txexpr-proc hyperlink-decoder
                                  #:string-proc smart-dashes
                                  #:exclude-tags '(script style))))
  body)
