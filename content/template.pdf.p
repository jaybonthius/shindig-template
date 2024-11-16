◊; Using comments in place of newlines, since the output is 
◊; a binary file and is sensitive to whitespace.
◊(define project-dir (string->path (getenv "PROJECT_DIR")))
◊(displayln (format "PROJECT_DIR=~a" (path->string project-dir)))
◊; 
◊(local-require racket/file racket/path racket/system sugar pollen/render)
◊(define working-directory (current-directory))
◊(define source-file-name (file-name-from-path (hash-ref metas 'here-path)))
◊(define job-name (remove-ext* source-file-name))
◊; 
◊(define path-name-without-extension (remove-ext* (hash-ref metas 'here-path)))
◊(define file-name-without-extension (remove-ext* (hash-ref metas 'here-path)))
◊(define tex-path (add-ext file-name-without-extension "tex"))
◊(render-to-file-if-needed (hash-ref metas 'here-path) (build-path project-dir "template.tex.p") tex-path)
◊(define temp-directory (build-path working-directory "temp"))
◊(current-directory project-dir)
◊; 
◊; temp-latexmk-dir is needed for some quirky latexmk reasons when \includeonly is used
◊(define temp-latexmk-dir (build-path temp-directory (find-relative-path (current-directory) working-directory)))
◊(make-directory* temp-latexmk-dir)
◊(define wholebook-path (build-path "wholebook.tex"))
◊(define command (format "latexmk -jobname='~a' -output-directory='~a' -pdf -usepretex='\\includeonly{~a}' wholebook.tex" job-name temp-directory (find-relative-path (current-directory) path-name-without-extension)))
◊(displayln command)
◊; 
◊(define result (system command))
◊; 
◊(if (system command)
    (file->bytes (build-path working-directory "temp" (add-ext job-name "pdf")))
    (error "latexmk: rendering error"))
