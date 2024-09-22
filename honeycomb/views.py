import logging

from django.http import HttpRequest, HttpResponse
from django.shortcuts import render
from django.template import RequestContext, TemplateDoesNotExist
from django.template.loader import get_template
from django.template.response import TemplateResponse
from django.views.decorators.http import require_GET, require_POST
from django_htmx.middleware import HtmxDetails
import json
import sqlite3

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


def check_answers(request):
    question_id = next(iter(request.POST.keys()))
    selected_answers = set(request.POST.getlist(question_id))

    template_name = f"question/{question_id}.html"

    conn = sqlite3.connect("pollen/questions.sqlite")
    cursor = conn.cursor()

    cursor.execute("SELECT answer FROM questions WHERE id = ?", (question_id,))
    result = cursor.fetchone()

    if result is None:
        return HttpResponse("Question not found", status=404)

    correct_answers = set(json.loads(result[0]))

    conn.close()

    context = {
        "selected_answers": selected_answers,
        "correct_answers": correct_answers,
        "is_correct": selected_answers == correct_answers,
        "is_submitted": True,
    }

    logger.info(f"Correct: {selected_answers == correct_answers}")

    if request.htmx:
        return render(request, template_name, context)
    return HttpResponse("Non-HTMX requests are not supported", status=400)


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
