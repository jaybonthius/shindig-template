◊(require html-printer pollen/pagetree)
◊(define source-file (select-from-metas 'here-path metas))
◊(define project-dir (string->path (getenv "PROJECT_DIR")))
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="description" content="Your description here" />
        <meta name="keywords" content="keyword1, keyword2, keyword3" />
        <title>Shindig</title>
        <link rel="icon" href="◊(baseurl)static/favicon.ico" type="image/x-icon">
        <link rel="stylesheet" href="◊(baseurl)static/css/output.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <script src="https://unpkg.com/hyperscript.org@0.9.12"></script>
        <script src="https://unpkg.com/htmx.org@1.9.10"
                integrity="sha384-D1Kt99CQMDuVetoL1lrYwg5t+9QdHe7NLX/SoJYkXDFfX37iInKRy5xLSi8nO7UC"
                crossorigin="anonymous"></script>
        <script src="https://unpkg.com/htmx.org@1.9.12/dist/ext/multi-swap.js"></script>
        <script src="https://unpkg.com/htmx-ext-debug@2.0.0/debug.js"></script>
        <script src="https://unpkg.com/htmx-ext-preload@2.0.1/preload.js"></script>
        <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.14.1/dist/cdn.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    </head>
    <body hx-boost="true" hx-ext="multi-swap,preload">
        <div class="layout-wrapper">
            <button class="sidebar-toggle" onclick="document.querySelector('.toc').classList.toggle('active')">
                <i class="fas fa-bars"></i>
            </button>
            <aside class="toc">
                ◊(define pagetree (get-pagetree (build-path project-dir "index.ptree")))
                ◊(displayln (format "template pagetree: ~a" pagetree))
                ◊(xexpr->html5 (generate-toc pagetree))
            </aside>
            <main>
                <div class="content-wrapper">
                    <div id="main">
                        <h1>◊(select-from-metas 'title here)</h1>

                        
                        ◊when/splice[(pdfable? source-file)]{
                            ◊(xexpr->html5 (pdf-download-button source-file))
                        }

                        <div class="content">◊(map xexpr->html5 (select-from-doc 'body here))</div>
                    </div>
                </div>
            </main>
        </div>
        <script defer type="module">
            const renderMath = () => import('//unpkg.com/mathlive?module').then(mathlive => mathlive.renderMathInDocument());
            
            window.addEventListener('DOMContentLoaded', renderMath);
            document.addEventListener('htmx:afterRequest', renderMath);
        </script>
    </body>
</html>