#lang racket

(require json)

(define (parse-http-request-string str)
  (define (parse-pair pair)
    (let* ([key-value (string-split pair "=")]
           [key (first key-value)]
           [value (string-join (rest key-value) "=")])
      (cons key (if (string-prefix? value "{")
                    (string->jsexpr value)
                    value))))
  
  (define (parse-submission submission)
    (if (and (hash? submission)
             (hash-has-key? submission 'uid))
        (hash-ref submission 'uid)
        #f))
  
  (let* ([pairs (string-split str "&")]
         [parsed-pairs (map parse-pair pairs)]
         [submissions (filter-map (lambda (pair)
                                    (and (equal? (car pair) "submissions")
                                         (cdr pair)))
                                  parsed-pairs)]
         )
    submissions))

;; Example usage
(define example-request "submissions={\"uid\":\"fr-field-zZWCtZ7J3FGeC7l2awieT\",\"latex\":\"1\"}&submissions={\"uid\":\"fr-field-__T1P_BblhsXJSHHsRMzP\",\"latex\":\"2\"}")
(parse-http-request-string example-request)