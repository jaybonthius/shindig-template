#lang racket/base

(require db
         json
         pollen/decode
         pollen/render
         pollen/template
         racket/file
         racket/list
         racket/pretty
         racket/set
         racket/string
         xml
         "sqlite.rkt"
         "../utils.rkt")

(provide (all-defined-out))

(define-struct fr-field-object (html metadata))

; (define (generate-hx-vals-string metadata-list)
;   (define (item->string h)
;     (format "{latex: document.getElementById('~a').value, uid: '~a'}"
;             (hash-ref h 'uid)
;             (hash-ref h 'uid)))
  
;   (define items-string
;     (string-join (map item->string metadata-list) ","))
  
;   (define hx-vals-string
;     (format "js:{submissions: [~a]}" items-string))
  
;   hx-vals-string)

(define (free-response #:uid (uid "") . content)
  (validate-uid uid)
  (set! uid (string-append "fr-question-" uid))
  
  (define metadata '())
  (define parsed-content '())

  (pretty-print content)

  (for ([item content])
    (if (fr-field-object? item)
        (begin
          (set! metadata (cons (fr-field-object-metadata item) metadata))
          (set! parsed-content (cons (fr-field-object-html item) parsed-content)))
        (set! parsed-content (cons item parsed-content))))
  (set! parsed-content (reverse parsed-content))

  (for ([item metadata])
    (upsert-question (hash-ref item 'uid) (hash-ref item 'answer)))

  ; (define submit-button-hx-vals (generate-hx-vals-string metadata))

  (pretty-print parsed-content)

  (define question-content
    `(div 
          (div ,@parsed-content)
          (button [(class "btn")
                   (hx-post ,(format "/free-response/~a" uid))
                  ;  (hx-vals ,submit-button-hx-vals)
                   ]
                   "Submit!")
                   ))
  (render-x-expression (quote-xexpr-attributes question-content) "free-response" uid)

  `(div ((id ,uid) (hx-get ,(format "/free-response/~a" uid))
                    (hx-trigger "load")
                    (hx-target "this"))
          "Loading...")
)

(define (fr-field #:uid [uid ""] #:answer [answer ""] #:placeholders [placeholders (hash)] . content)
  (validate-uid uid)
  (set! uid (string-append "fr-field-" uid))
  
  (define answer-provided? (not (string=? answer "")))
  (define placeholders-provided? (not (hash-empty? placeholders)))

  (cond
    [(and answer-provided? placeholders-provided?)
     (raise-argument-error 'fr-field "answer and placeholders cannot both be provided" (list answer placeholders))]
    [(not (or answer-provided? placeholders-provided?))
     (raise-argument-error 'fr-field "either answer or placeholders must be provided" (list answer placeholders))]
    [answer-provided? (fr-field-answer uid answer)]
    ; [placeholders-provided? (fr-field-placeholders uid placeholders content)]
    )
)



(define (fr-field-answer uid answer)
  (define html `(div (math-field [(id ,uid) (name ,uid) (style "display: block")])))
  (make-fr-field-object html (hash 'uid uid 'answer answer)))

(define (fr-field-placeholders uid placeholders content)
  (define html `(div (math-field [(id ,uid) (name ,uid)] ,@content)))
  (make-fr-field-object html (hash 'uid uid 'placeholders placeholders)))

; test 

; (fr-container #:uid "Lzpw5LEviNx4INfuN3W5p"
;               "This is some good stuff!!! Yahoo!!"
;               ; (fr-field #:uid "WkRqouD4ql1-kAqYnxBMS" #:placeholders (hash 'numerator "5" 'denominator "4") "\\frac{15}{12} = \\frac{\\placeholder[numerator]{?}}{\\placeholder[denominator]{?}}")
;               (fr-field #:uid "zZWCtZ7J3FGeC7l2awieT" #:answer "3")
;               (fr-field #:uid "smBDN0w0DyGLhrE0OB5Db" #:answer "7")
;               )


