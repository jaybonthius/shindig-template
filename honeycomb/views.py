from django.http import HttpRequest, HttpResponse
from django.shortcuts import render
from django.template.loader import render_to_string
from django.views.decorators.http import require_GET, require_POST
from django_htmx.middleware import HtmxDetails
from django.template import RequestContext
from django.template.response import TemplateResponse


class HtmxHttpRequest(HttpRequest):
    htmx: HtmxDetails


@require_GET
def index(request: HtmxHttpRequest) -> HttpResponse:
    return page(request, "index")


@require_GET
def page(request, page):
    request_context = RequestContext(
        request,
        {
            "page": page,
        },
    )
    context_dict = request_context.flatten()

    page_content = TemplateResponse(
        request, f"{page}.html", context=context_dict
    ).rendered_content

    if request.headers.get("HX-Request") == "true":
        return HttpResponse(page_content)
    else:
        return render(
            request, "base.html", {"page_content": page_content, **context_dict}
        )


@require_POST
def check_answers(request):
    return "<div>Answers checked!</div>"
