<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        ◊; <title>Your Website - ◊(select-from-metas 'title here)</title>
        <title>◊(hash-ref metas 'title)</title>
        <link href="./css/output.css" rel="stylesheet">
    </head>
    <body class="bg-gray-100 text-gray-900 antialiased leading-tight">
        <div class="min-h-screen flex flex-col">
            <main class="flex-grow">
                <div class="container mx-auto px-4 py-6 sm:py-8 lg:py-12 prose prose-sm sm:prose lg:prose-lg xl:prose-xl max-w-none">
                    <h1 class="text-3xl sm:text-4xl lg:text-5xl font-bold mb-4">◊(select-from-metas 'title here)</h1>
                    <div class="content">
                        ◊(map ->html (select-from-doc 'body here))
                    </div>
                </div>
            </main>
            <footer class="bg-gray-200 mt-8">
                <div class="container mx-auto px-4 py-4 text-center">
                    <p>&copy; 2024 Your Company</p>
                </div>
            </footer>
        </div>
    </body>
</html>