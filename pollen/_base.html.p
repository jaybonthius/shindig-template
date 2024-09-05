{% load static %}
<!DOCTYPE html>
<html lang="en" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="description" content="Your description here" />
        <meta name="keywords" content="keyword1, keyword2, keyword3" />
        <title>Honeycomb</title>
        <link href="{% static 'css/output.css' %}" rel="stylesheet" />
        <script src="{% static 'js/theme.js' %}"></script>
        <script src="https://unpkg.com/htmx.org@1.9.10"
                integrity="sha384-D1Kt99CQMDuVetoL1lrYwg5t+9QdHe7NLX/SoJYkXDFfX37iInKRy5xLSi8nO7UC"
                crossorigin="anonymous"></script>
    </head>
    <body class="antialiased leading-tight">
        <div class="min-h-screen flex flex-col">
            <div class="drawer lg:drawer-open flex-grow">
                <input id="my-drawer-2" type="checkbox" class="drawer-toggle" />
                <div class="drawer-content flex flex-col">
                    <main class="flex-grow">
                        <div class="container max-w-none mx-auto px-4 py-6 sm:py-8 lg:py-12 prose prose-sm sm:prose lg:prose-lg xl:prose-xl">
                            <label for="my-drawer-2"
                                   class="btn btn-primary drawer-button lg:hidden mb-4">Open drawer</label>
                            <div class="mb-4">
                                <select data-choose-theme class="max-w-xs select select-bordered w-full">
                                    <option value="light">Light</option>
                                    <option value="dark">Dark</option>
                                    <option value="retro">Retro light</option>
                                    <option value="gruvbox_light">Gruvbox light</option>
                                    <option value="gruvbox_dark">Gruvbox dark</option>
                                </select>
                            </div>
                            <div id="main">
                                {% block main %}{% endblock %}
                            </div>
                        </div>
                    </main>
                </div>
                <div class="drawer-side">
                    <label for="my-drawer-2" aria-label="close sidebar" class="drawer-overlay"></label>
                    <ul class="bg-base-100 menu menu-lg w-56 min-h-full p-4"
                        hx-target="#main"
                        hx-boost="true">
                        <li>
                            <a href="/page1/"
                               :class="'/page1/' === currentPath { } 'active':"
                               class="text-base-content no-underline">Page 1</a>
                        </li>
                        <li>
                            <a href="/page2/"
                               :class="'/page2/' === currentPath { } 'active':"
                               class="text-base-content no-underline">Page 2</a>
                        </li>
                        <li>
                            <a href="/page3/"
                               :class="'/page3/' === currentPath { } 'active':"
                               class="text-base-content no-underline">Page 3</a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </body>
</html>
