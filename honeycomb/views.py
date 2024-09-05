from django.shortcuts import render
from django.http import HttpResponse
from django.views.decorators.http import require_GET
from django_htmx.middleware import HtmxDetails
from django.http import HttpRequest

class HtmxHttpRequest(HttpRequest):
    htmx: HtmxDetails

@require_GET
def index(request: HtmxHttpRequest) -> HttpResponse:
    return render(request, "index.html")

# @require_GET
# def page(request: HtmxHttpRequest, page) -> HttpResponse:
#     return render(request, f"{page}.html")

@require_GET
def page(request: HtmxHttpRequest, page) -> HttpResponse:
    if request.htmx:
        print("This is an Htmx request")
        base_template = "_partial.html"
    else:
        print("This is a regular request")
        base_template = "_base.html"
    boosted = request.headers.get("HX-Boosted")

    print(f"Boosted: {boosted}")
    print(f"request.path: {request.path}")

    return render(
        request,
        f"{page}.html",
        {
            "base_template": base_template,
        },
    )