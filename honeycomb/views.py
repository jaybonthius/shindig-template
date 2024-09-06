from django.shortcuts import render
from django.http import HttpResponse
from django.views.decorators.http import require_GET
from django_htmx.middleware import HtmxDetails
from django.http import HttpRequest
from django.template.loader import render_to_string

class HtmxHttpRequest(HttpRequest):
    htmx: HtmxDetails

@require_GET
def index(request: HtmxHttpRequest) -> HttpResponse:
    return page(request, 'index')

@require_GET
def page(request: HtmxHttpRequest, page) -> HttpResponse:
    page_content = render_to_string(f"{page}.html")
    
    if request.htmx:
        return HttpResponse(page_content)
    else:
        return render(request, "base.html", {'page_content': page_content})
    