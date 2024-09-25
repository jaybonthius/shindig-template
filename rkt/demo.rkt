#lang racket/base


(require "modules/raw/raw.rkt"
            "modules/html-printer/main.rkt")


(define foo "Bar")

(display (xexpr->html5 
    `(html 
        ,(raw `(define thing "Bar"))
        (head
            (title ,(format "Fastest @thing in the @|place|!"))
        )
        (body 
            (h1 "Bang!")
            (h2 "Bang!")
        )
    )
))
