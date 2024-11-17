◊(define project-dir (string->path (getenv "PROJECT_DIR")))
◊(define pagetree (get-pagetree (build-path project-dir "tex.ptree")))
◊(define has-parent-page (parent here pagetree))
◊(define type (path->string (car (explode-path (symbol->string here)))))
◊when/splice[(equal? type "chapter")]{
    ◊when/splice[(not has-parent-page)]{ 
        \chapter{◊(hash-ref metas 'title)}
    }
    ◊when/splice[has-parent-page]{
        \section{◊(hash-ref metas 'title)}
    }
}
◊when/splice[(equal? type "frontmatter")]{ 
    \chapter*{◊(hash-ref metas 'title)}
    \addcontentsline{toc}{chapter}{◊(hash-ref metas 'title)}
}
◊(apply string-append (cdr doc))
