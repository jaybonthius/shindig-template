web: raco koyo serve --watch-pattern "backend" --watch-exclude "content" --watch-exclude "compiled" --log-watched-files
pollen: make pollen-server
app: pnpm run app
tailwind: pnpx tailwindcss -i static/css/input.css -o static/css/output.css --watch
filesaver: ./scripts/filesaver.sh