{% load static %}
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="description" content="Your description here" />
        <meta name="keywords" content="keyword1, keyword2, keyword3" />
        <title>Honeycomb</title>
        <link href="{% static 'css/output.css' %}" rel="stylesheet" />
        <script src="https://unpkg.com/htmx.org@1.9.10"
                integrity="sha384-D1Kt99CQMDuVetoL1lrYwg5t+9QdHe7NLX/SoJYkXDFfX37iInKRy5xLSi8nO7UC"
                crossorigin="anonymous"></script>
    </head>
    <body class="antialiased leading-tight">
        <div class="min-h-screen flex flex-col">
            <main class="flex-grow">
                <div class="container max-w-none mx-auto px-4 py-6 sm:py-8 lg:py-12 prose prose-sm sm:prose lg:prose-lg xl:prose-xl">
                    <ul>
                        <li>
                            <a href="/" hx-get="/" hx-target="#main" hx-push-url="true">Home</a>
                        </li>
                        <li>
                            <a href="/page1/" hx-get="/page1/" hx-target="#main" hx-push-url="true">Page 1</a>
                        </li>
                        <li>
                            <a href="/page2/" hx-get="/page2/" hx-target="#main" hx-push-url="true">Page 2</a>
                        </li>
                        <li>
                            <a href="/page3/" hx-get="/page3/" hx-target="#main" hx-push-url="true">Page 3</a>
                        </li>
                    </ul>
                    <div id="main">{{ page_content }}</div>
                </div>
            </main>
        </div>
    </body>
</html>
