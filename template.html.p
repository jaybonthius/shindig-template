<!doctype html>
<html lang="en" data-theme="light">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>◊(hash-ref metas 'title)</title>
    <link href="./css/output.css" rel="stylesheet" />
    <script src="./js/theme.js"></script>
  </head>
  <body class="antialiased leading-tight">
    <div class="min-h-screen flex flex-col">
      <div class="drawer lg:drawer-open flex-grow">
        <input id="my-drawer-2" type="checkbox" class="drawer-toggle" />
        <div class="drawer-content flex flex-col">
          <main class="flex-grow">
            <div class="container max-w-none mx-auto px-4 py-6 sm:py-8 lg:py-12 prose prose-sm sm:prose lg:prose-lg xl:prose-xl">
              <label for="my-drawer-2" class="btn btn-primary drawer-button lg:hidden mb-4"> Open drawer </label>
              <h1 class="text-3xl mb-4 font-bold sm:text-4xl lg:text-5xl">◊(select-from-metas 'title here)</h1>
              <div class="mb-4">
                <select data-choose-theme class="max-w-xs select select-bordered w-full">
                  <option value="light">Light</option>
                  <option value="dark">Dark</option>
                  <option value="retro">Retro light</option>
                  <option value="gruvbox_light">Gruvbox light</option>
                  <option value="gruvbox_dark">Gruvbox dark</option>
                </select>
              </div>

              <div class="content">◊(map ->html (select-from-doc 'body here))</div>
            </div>
          </main>
        </div>
        <div class="drawer-side">
          <label for="my-drawer-2" aria-label="close sidebar" class="drawer-overlay"></label>
          <ul class="bg-base-100 menu menu-lg w-56 min-h-full p-4">
            <li><a class="text-base-content no-underline">Item 1</a></li>
            <li><a class="text-base-content no-underline">Item 2</a></li>
            <li><a class="text-base-content no-underline">Item 3</a></li>
          </ul>
        </div>
      </div>
    </div>
  </body>
</html>
