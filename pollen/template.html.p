○(require "../rkt/modules/html-printer/main.rkt")
<h1>○(select-from-metas 'title here)</h1>
<div class="content">○(map xexpr->html5 (select-from-doc 'body here))</div>
