<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>◊(hash-ref metas 'title)</title>
    <link href="./css/output.css" rel="stylesheet" />
  </head>
  <body class="antialiased leading-tight">
    <div class="min-h-screen flex flex-col">
      <main class="flex-grow">
        <div class="container max-w-none mx-auto px-4 py-6 sm:py-8 lg:py-12 prose prose-sm sm:prose lg:prose-lg xl:prose-xl">
          <h1 class="text-3xl mb-4 font-bold sm:text-4xl lg:text-5xl">◊(select-from-metas 'title here)</h1>
          <div class="content">◊(map ->html (select-from-doc 'body here))</div>
        </div>
      </main>
    </div>
  </body>
</html>
