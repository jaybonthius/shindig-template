○(require "../rkt/modules/html-printer/main.rkt")
<h1 class="text-3xl mb-4 font-bold sm:text-4xl lg:text-5xl">○(select-from-metas 'title here)</h1>
<div class="content">○(map xexpr->html5 (select-from-doc 'body here))</div>
