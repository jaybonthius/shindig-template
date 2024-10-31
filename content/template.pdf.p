◊(local-require racket/file racket/system)
◊(define latex-source ◊string-append{
    \documentclass{article}
    \usepackage{amsmath}
    \usepackage{graphicx}
    \usepackage{mathtools}
    \title{◊(hash-ref metas 'title)}
    \author{}
    \date{}
    \begin{document}
    \maketitle
    ◊(apply string-append (cdr doc))
    \end{document}
})

◊(define working-directory
    (build-path (current-directory) "pollen-latex-work"))
◊(unless (directory-exists? working-directory)
    (make-directory working-directory))
◊(define temp-ltx-path (build-path working-directory "temp.ltx"))
◊(display-to-file latex-source temp-ltx-path #:exists 'replace)
◊(define command (format "xelatex -output-directory='~a' '~a'" working-directory temp-ltx-path))
◊(if (system command)
    (file->bytes (build-path working-directory "temp.pdf"))
    (error "xelatex: rendering error"))
