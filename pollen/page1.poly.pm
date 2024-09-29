#lang pollen

○(define-meta title     "Page 1")

This is the first page!


This is a button: ○button[#:class "btn"]{Go to page 2}.

Here is some inline code: ○code{(+ 1 2)}.

○div[#:class "bg-slate-400 text-black"]{This should be blue!}

○div[#:class ○(string-append "bg-" "green-500")]{This should be red!}

○(div '[[style "text-align: center"]] "This should be pink!")
