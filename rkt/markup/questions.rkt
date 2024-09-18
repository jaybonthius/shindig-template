#lang racket/base

(require racket/file
         racket/string
         racket/list
         pollen/render
         pollen/decode
         racket/pretty
         racket/string
         xml
         pollen/template)

(provide (all-defined-out))

(require racket/match)

(define (quote-xexpr-attributes xexpr)
  (match xexpr
    [(list tag (and attrs (list (list _ _) ...)) content ...)
     (list* tag `'(,@attrs) (map quote-xexpr-attributes content))]
    [(list tag content ...) (cons tag (map quote-xexpr-attributes content))]
    [else xexpr]))

(define (option #:correct [correct #f] #:id [id ""] . content)
  `(option ((correct ,correct) (id ,id)) ,@content))

(define (get-correct-answers items)
  (define (process-item item)
    (if (and (list? item) (eq? (car item) 'option))
        (let ([attrs (cadr item)])
          (if (and (list? attrs)
                   (assq 'correct attrs)
                   (eq? #t (cadr (assq 'correct attrs))))
              (list (cadr (assq 'id attrs)))
              '()))
        (if (list? item) (process-items item) '())))

  (define (process-items items)
    (apply append (map process-item items)))
  (process-items items))

(define (new-question #:uuid [uuid #f] #:multichoice [multichoice #f] . content)
  (define option-type (if multichoice "checkbox" "radio"))

  (define (render-option item)
    (if (and (list? item) (eq? (car item) 'option))
        (let* ([attrs (cadr item)]
               [id (string-join (list uuid (cadr (assq 'id attrs))) "-")]
               [option-content (cddr item)])
          `(div ((class "flex items-center"))
                (input ((type ,option-type)
                        (id ,id)
                        (name ,uuid)
                        (value ,id)
                        (class ,(string-join (list option-type "mr-6") " "))))
                (label ((for ,id
                          ))
                       ,@option-content)))
        item))

  (define (split-content items)
    (let loop ([items items]
               [question-content '()]
               [options '()])
      (if (null? items)
          (values (reverse question-content) (reverse options))
          (let ([item (car items)])
            (if (and (list? item) (eq? (car item) 'option))
                (loop (cdr items) question-content (cons item options))
                (loop (cdr items) (cons item question-content) options))))))

  (define (remove-trailing-newlines items)
    (let loop ([items (reverse items)]
               [result '()])
      (cond
        [(null? items) result]
        [(and (string? (car items)) (string=? (car items) "\n"))
         (if (null? result) (loop (cdr items) result) (reverse items))]
        [else (reverse items)])))

  (define divider '(div ((class "divider"))))

  (define-values (question-content options) (split-content content))
  (define cleaned-question-content (remove-trailing-newlines question-content))
  (define rendered-options (add-between (map render-option options) divider))
  (define submit-button `(button ((type "submit") (class "btn")) "Submit!"))

  (define expression
    `(form ((id ,uuid) (hx-post "{% url 'check_answers' %}")
                       (hx-target "this")
                       (hx-include "this"))
           ,@cleaned-question-content
           ,@rendered-options
           ,submit-button))

  (render-x-expression (quote-xexpr-attributes expression) "question" uuid)

  (define question-content-id (string-append "question-content-" uuid))

  (define question-getter
    `(div ((id ,question-content-id)
           (hx-get ,(format "{% url 'question_detail' id='~a' %}" uuid))
           (hx-trigger "load")
           (hx-target ,(string-append "#" question-content-id)))
          "Loading..."))

  question-getter)

(define (render-x-expression xexpr prefix filename)
  (define temp-dir (build-path (current-directory) "temp"))
  (define temp-path (build-path temp-dir (string-append filename ".html.pm")))
  (define output-dir (build-path (current-directory) prefix))
  (define output-path (build-path output-dir (string-append filename ".html")))

  (make-directory* temp-dir)
  (make-directory* output-dir)

  (with-output-to-file temp-path
                       (lambda ()
                         (displayln "#lang pollen")
                         (display "◊")
                         (write xexpr))
                       #:exists 'replace)

  (render-to-file-if-needed temp-path #f output-path)
  output-path)
