#lang pollen
◊(require pollen/pagetree)
◊; TODO: support twoside / openany
◊; https://tex.stackexchange.com/questions/111580/removing-an-unwanted-page-between-two-chapters
\documentclass[oneside]{shindig_book}
\usepackage{hyperref}
\usepackage{amsmath}
\usepackage{graphicx}
\usepackage{mathtools}
\usepackage[english]{babel}

\title{Shindig demo}
\author{Jay Bonthius}
\makeindex
◊; \usepackage[totoc]{idxlayout}
\usepackage[nottoc]{tocbibind}

\begin{document}
◊(define pagetree (get-pagetree "tex.ptree"))
◊(generate-input-toc pagetree)
\end{document}
