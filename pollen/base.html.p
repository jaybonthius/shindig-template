<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="description" content="Your description here" />
        <meta name="keywords" content="keyword1, keyword2, keyword3" />
        <title>Honeycomb</title>
        <link href="../static/css/output.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>
    <body class="antialiased leading-tight" hx-boost="true" hx-ext="multi-swap">
        <div class="drawer" x-data="{ activePage: window.location.pathname }">
            <input id="my-drawer" type="checkbox" class="drawer-toggle" />
            <div class="drawer-content">
                <div class="min-h-screen flex flex-col">
                    <div class="navbar bg-base-100">
                        <div class="flex-none">
                            <label for="my-drawer" class="btn btn-square btn-ghost">
                                <svg
                                    xmlns="http://www.w3.org/2000/svg"
                                    fill="none"
                                    viewBox="0 0 24 24"
                                    class="inline-block h-5 w-5 stroke-current">
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M4 6h16M4 12h16M4 18h16"></path>
                                </svg>
                            </label>
                        </div>
                        <div class="flex-1">
                            <a class="btn btn-ghost text-xl" href="/" 
                            hx-get="/" 
                            hx-target="#main" 
                            hx-push-url="true"
                            @click="activePage = '/'"
                            :class="{ 'active': activePage === '/' }">Honeycomb</a>
                        </div>
                        <div class="flex-none">
                            <button class="btn btn-square btn-ghost">
                                <svg
                                    xmlns="http://www.w3.org/2000/svg"
                                    fill="none"
                                    viewBox="0 0 24 24"
                                    class="inline-block h-5 w-5 stroke-current">
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z"></path>
                                </svg>
                            </button>
                        </div>
                    </div>
                    <main class="flex-grow flex">
                        <div class="container max-w-none mx-auto px-4 py-6 sm:py-8 xl:py-12 xl:pl-8 prose !prose-butterick dark:!prose-invert prose-sm sm:prose lg:prose-lg xl:prose-xl">
                            <div id="main">
                                ●|lesson-content|
                            </div>
                        </div>
                    </main>
                </div>
            </div>
            <div class="drawer-side">
                <label for="my-drawer" aria-label="close sidebar" class="drawer-overlay"></label>
                <ul class="menu bg-base-200 text-base-content min-h-full w-80 p-4 text-base sm:text-sm lg:text-lg xl:text-xl">
                    <li>
                        <a href="/" 
                           hx-get="/" 
                           hx-target="#main" 
                           hx-push-url="true"
                           @click="activePage = '/'"
                           :class="{ 'active': activePage === '/' }">Home</a>
                    </li>
                    <li>
                        <a href="/lesson/page1" 
                           hx-get="/lesson/page1" 
                           hx-target="#main" 
                           hx-push-url="true"
                           @click="activePage = '/lesson/page1'"
                           :class="{ 'active': activePage === '/lesson/page1' }">Page 1</a>
                    </li>
                    <li>
                        <a href="/lesson/page2" 
                           hx-get="/lesson/page2" 
                           hx-target="#main" 
                           hx-push-url="true"
                           @click="activePage = '/lesson/page2'"
                           :class="{ 'active': activePage === '/lesson/page2' }">Page 2</a>
                    </li>
                    <li>
                        <a href="/lesson/page3" 
                           hx-get="/lesson/page3" 
                           hx-target="#main" 
                           hx-push-url="true"
                           @click="activePage = '/lesson/page3'"
                           :class="{ 'active': activePage === '/lesson/page3' }">Page 3</a>
                    </li>
                    <li>
                        <a href="/lesson/how-do-we-measure-velocity" 
                           hx-get="/lesson/how-do-we-measure-velocity" 
                           hx-target="#main" 
                           hx-push-url="true"
                           @click="activePage = '/lesson/how-do-we-measure-velocity'"
                           :class="{ 'active': activePage === '/lesson/page3' }">How do we measure velocity?</a>
                    </li>
                </ul>
            </div>
        </div>
        <script src="https://unpkg.com/htmx.org@1.9.10"
                integrity="sha384-D1Kt99CQMDuVetoL1lrYwg5t+9QdHe7NLX/SoJYkXDFfX37iInKRy5xLSi8nO7UC"
                crossorigin="anonymous"></script>
        <script src="https://unpkg.com/htmx.org@1.9.12/dist/ext/multi-swap.js"></script>
        <script src="https://unpkg.com/htmx-ext-debug@2.0.0/debug.js"></script>
        <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.14.1/dist/cdn.min.js"></script>
        <script defer type="module">
            window.addEventListener('DOMContentLoaded', () => 
              import('//unpkg.com/mathlive?module').then((mathlive) => 
                mathlive.renderMathInDocument()
              )
            );
        </script>
    </body>
</html>