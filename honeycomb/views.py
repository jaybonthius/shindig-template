import logging

from django.http import HttpRequest, HttpResponse
from django.shortcuts import render
from django.template import RequestContext, TemplateDoesNotExist
from django.template.loader import get_template
from django.template.response import TemplateResponse
from django.views.decorators.http import require_GET, require_POST
from django_htmx.middleware import HtmxDetails

logger = logging.getLogger("honeycomb")


class HtmxHttpRequest(HttpRequest):
    htmx: HtmxDetails


@require_GET
def index(request: HtmxHttpRequest) -> HttpResponse:
    return page(request, "index")


@require_GET
def page(request, page):
    logger.info("Page requested: %s", page)
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
    logger.info("POST request received!")
    logger.info(f"Contents: {request.POST}")
    logger.info(f"Headers: {request.headers}")
    logger.info(f"Body: {request.body}")
    return HttpResponse("POST request received!")


def question_detail(request, id):
    template_name = f"question/{id}.html"

    try:
        template = get_template(template_name)
        content = template.render()

        if request.htmx:
            return HttpResponse(content)
        return render(request, template_name)

    except TemplateDoesNotExist:
        return HttpResponse(f"Question template not found: {template_name}", status=404)
