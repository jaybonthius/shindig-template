#lang racket

(require xml)
(require "../modules/html-printer/main.rkt")

(define (checkbox-button id label)
  `(div
    (input ([type "checkbox"] [id ,id] [name ,id] (class "hidden peer")))
    (label
     ((for ,id
        )
      (class "inline-block px-6 py-3 text-sm font-medium text-gray-700 bg-gray-100 border-2 border-gray-300 rounded-md cursor-pointer transition-colors peer-checked:bg-blue-500 peer-checked:text-white peer-checked:border-blue-500 hover:bg-gray-200 peer-checked:hover:bg-blue-600"))
     ,label)))

(define html-doc
  `(body ((class "p-6"))
         (form (div ((class "space-y-4")) ,(checkbox-button "option1" "Option 1")))))

(display (xexpr->html5 html-doc))
