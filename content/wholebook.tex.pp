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
\makeindex
◊; \usepackage[totoc]{idxlayout}
\usepackage[nottoc]{tocbibind}

\begin{document}
◊(define pagetree (get-pagetree "tex.ptree"))
◊(generate-input-toc pagetree)
\end{document}
