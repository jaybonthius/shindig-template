from django.conf import settings
from django.conf.urls import include
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import path, re_path

# Remove this when you start your proejct
from django.views import debug
from django.views.generic.base import RedirectView

favicon_view = RedirectView.as_view(url="/static/favicon.ico", permanent=True)

urlpatterns = [
    re_path(r"^favicon\.ico$", favicon_view),
    path("", include("honeycomb.urls")),
    path("admin/", admin.site.urls),
    path("", debug.default_urlconf),
]


if settings.DEBUG:
    import debug_toolbar

    urlpatterns += [
        path("__debug__/", include(debug_toolbar.urls)),
    ]
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
