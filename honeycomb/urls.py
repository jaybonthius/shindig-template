from django.urls import path

from . import views

urlpatterns = [
    path("", views.index, name="index"),
    path("question/<str:id>/", views.question_detail, name="question_detail"),
    path("check-answers/", views.check_answers, name="check_answers"),
    path("<str:page>/", views.page, name="page"),
    # ^^^ this HAS to go last. fix this!!!
]
