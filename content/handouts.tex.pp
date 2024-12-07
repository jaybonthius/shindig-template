#lang pollen
◊(require pollen/pagetree
         (prefix-in config: "config.rkt"))
◊; TODO: support twoside / openany
◊; https://tex.stackexchange.com/questions/111580/removing-an-unwanted-page-between-two-chapters
\documentclass[oneside]{shindig_book}
\usepackage{hyperref}
\usepackage{amsmath}
\usepackage{graphicx}
\usepackage{mathtools}
\usepackage[english]{babel}

\title{◊|config:book-title|}
\author{◊|config:author|}

\begin{document}
◊(define pagetree (get-pagetree "tex.ptree"))
◊(generate-toc pagetree)
\end{document}
