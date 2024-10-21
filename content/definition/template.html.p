◊(require html-printer)
◊(map xexpr->html5 (select-from-doc 'body here))
