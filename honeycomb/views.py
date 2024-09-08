from django.http import HttpRequest, HttpResponse
from django.shortcuts import render
from django.template.loader import render_to_string
from django.views.decorators.http import require_GET
from django_htmx.middleware import HtmxDetails


class HtmxHttpRequest(HttpRequest):
    htmx: HtmxDetails


@require_GET
def index(request: HtmxHttpRequest) -> HttpResponse:
    return page(request, "index")


@require_GET
def page(request: HtmxHttpRequest, page) -> HttpResponse:
    page_content = render_to_string(f"{page}.html")

    if request.htmx:
        return HttpResponse(page_content)
    else:
        return render(request, "base.html", {"page_content": page_content})
