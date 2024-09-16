from django.urls import path

from . import views
from django.views.decorators.csrf import csrf_exempt


urlpatterns = [
    path("", views.index, name="index"),
    path(f"<str:page>/", views.page, name="page"),
    path("check-answers/", views.check_answers, name="check_answers"),
]
