#lang racket/base

(require racket/string
         racket/list)

(provide (all-defined-out))

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

  ;         <div class="flex items-center">
  ;             <input type="radio" id="paris" name="capital" value="Paris" class="mr-2">
  ;             <label for="paris">Paris</label>
  ;         </div>

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

  ; ◊button[#:class "btn" #:type "submit" #:hx-post "/check-answers" #:hx-target "body" #:hx-include "#quiz-form"]{Submit!}

  (define submit-button `(button ((type "submit") (class "btn")) "Submit!"))

  `(form ((id ,uuid) (hx-post "{% url 'check_answers' %}")
                     (hx-target "body")
                     (hx-include ,(string-append "#" uuid)))
         "{% csrf_token %}"
         ,@cleaned-question-content
         (div ((class "space-y-2 mb-6")))
         ,@rendered-options
         ,submit-button))

; <form>
;     <p>What is the capital of France?</p>
;     <div class="space-y-2 mb-6">
;         <div class="flex items-center">
;             <input type="radio" id="paris" name="capital" value="Paris" class="mr-2">
;             <label for="paris">Paris</label>
;         </div>
;         <div class="flex items-center">
;             <input type="radio" id="london" name="capital" value="London" class="mr-2">
;             <label for="london">London</label>
;         </div>
;         <div class="flex items-center">
;             <input type="radio" id="berlin" name="capital" value="Berlin" class="mr-2">
;             <label for="berlin">Berlin</label>
;         </div>
;         <div class="flex items-center">
;             <input type="radio" id="rome" name="capital" value="Rome" class="mr-2">
;             <label for="rome">Rome</label>
;         </div>
;     </div>
;     <button type="submit" class="btn">Submit Answer</button>
; </form>
