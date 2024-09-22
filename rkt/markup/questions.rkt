#lang at-exp racket/base

(require racket/file
         racket/string
         racket/list
         racket/set
         pollen/render
         pollen/decode
         racket/pretty
         racket/string
         xml
         pollen/template
         "sqlite.rkt"
         json
         db)

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

; <div class="flex items-center {% if 'option-id' in selected_answers %}{% if 'option-id' in correct_answers %}bg-green-100{% else %}bg-red-100{% endif %}{% endif %}">
;     <label for="option-id">
;         <input type="checkbox"
;                id="option-id"
;                name="dbcf89c7-839c-424c-ba8e-048267c5e305"
;                value="option-id"
;                class="checkbox mr-6"
;                {% if 'option-id' in selected_answers %}checked{% endif %}
;                {% if is_submitted %}disabled{% endif %} />
;         Lorem ipsum dolor sit amet
;     </label>
;     {% if 'option-id' in selected_answers %}
;         {% if 'option-id' in correct_answers %}
;             <span class="text-green-600 ml-2">✓ Correct</span>
;         {% else %}
;             <span class="text-red-600 ml-2">✗ Incorrect</span>
;         {% endif %}
;     {% endif %}
; </div>

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
          (define correct-option "btn-success")
          (define incorrect-option "btn-error")
          `(div
            ((class "flex items-center"))
            (label
             ((for ,id
                )
              (class ,(string-join (list "btn btn-block justify-start items-center"
                                         (format "{% if '~a' in selected_answers %}" id)
                                         (format "{% if '~a' in correct_answers %}" id)
                                         correct-option
                                         "{% else %}"
                                         incorrect-option
                                         "{% endif %}"
                                         "{% else %}"
                                         "btn-ghost"
                                         "{% endif %}")
                                   " ")))
             (input ((type ,option-type)
                     (id ,id)
                     (name ,uuid)
                     (value ,id)
                     (class ,(string-join (list option-type "mr-4") " "))
                     (template-directive
                      ,(format "{% if '~a' in selected_answers %}checked{% endif %}"
                               id))
                     ;  (template-directive "{% if is_submitted %}disabled{% endif %}")
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

  (define-values (question-content options) (split-content content))
  (define cleaned-question-content (remove-trailing-newlines question-content))
  (define rendered-options `(div ((class "space-y-2")) ,@(map render-option options)))
  (define submit-button `(button ((type "submit") (class "btn")) "Submit!"))

  (define correct-answers
    (map (lambda (answer) (string-append uuid "-" answer))
         (get-correct-answers content)))

  (define question-content-id (string-append "question-content-" uuid))

  (define expression
    `(form ((id ,uuid) (hx-post "{% url 'check_answers' %}")
                       (hx-target "this")
                       (hx-include "this")
                       (hx-swap "outerHTML"))
           ,@cleaned-question-content
           ,rendered-options
           ,submit-button))

  (define question-getter
    `(div ((id ,question-content-id)
           (hx-get ,(format "{% url 'question_detail' id='~a' %}" uuid))
           (hx-trigger "load")
           (hx-target ,(string-append "#" question-content-id)))
          "Loading..."))

  (upsert-question uuid correct-answers)
  (render-x-expression (quote-xexpr-attributes expression) "question" uuid)

  question-getter)

(define (render-x-expression xexpr prefix filename)
  (define output-dir (build-path (current-directory) prefix))
  (define temp-dir (build-path output-dir "temp"))
  (define temp-path (build-path temp-dir (string-append filename ".html.pm")))
  (define output-path (build-path output-dir (string-append filename ".html")))
  (define template-path (build-path output-dir "question-template.html.p"))

  (make-directory* temp-dir)
  (make-directory* output-dir)

  (with-output-to-file temp-path
                       (lambda ()
                         (displayln "#lang pollen")
                         (display "◊")
                         (write xexpr))
                       #:exists 'replace)

  (render-to-file-if-needed temp-path template-path output-path)
  output-path)

(define (upsert-question question-id correct-answers-set)
  (define current-dir (current-directory))
  (define db-file (build-path current-dir "questions.sqlite"))
  ; todo: have this be a separate thing upon local setup
  (try-create-empty-file db-file)

  (define conn (try-connect db-file))
  (when conn
    (with-handlers ([exn:fail? (lambda (e)
                                 (printf "Error during database operations: ~a\n"
                                         (exn-message e)))])
      ; todo: have this be a separate thing upon local setup
      (query-exec
       conn
       "CREATE TABLE IF NOT EXISTS questions (
                id TEXT PRIMARY KEY NOT NULL,
                answer JSON,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )")

      (define json-answers (jsexpr->string correct-answers-set))

      (printf "Inserting or replacing question with id ~a and answers ~a\n"
              question-id
              json-answers)

      (query-exec
       conn
       "INSERT OR REPLACE INTO questions (id, answer)
                   VALUES (?, json(?))"
       question-id
       json-answers)

      (disconnect conn)

      (printf "Database operations completed successfully.\n"))))
