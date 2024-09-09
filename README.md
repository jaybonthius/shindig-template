
TODOS:
- excalidraw
  - find a CLI version?
  - `.excalidraw` -> `.dark.svg` and `.light.svg` (and `.png` probably too)
- [Manim slides](https://manim-slides.eertmans.be/latest/)
- Reveal.js support
- as an alternative (or in addition) to Reveal.js support, what about a feature where between every paragraph, youo can click a button that expands a drawing region? and just generally being able to annotate the page?
- print outs
  - LaTeX?
  - pollen target for an 8.5" x 11" HTML version of the webpage, and then print that out?
  - holy shit! [you can define a CSS class that hides elements when printing](https://stackoverflow.com/a/55169528)



ssh -i "honeycomb.pem" ubuntu@ec2-13-59-116-135.us-east-2.compute.amazonaws.com

## Racket dependencies

- `pollen`
- `chief`
- `racket-langserver` (if you want to use the recommended VS Code extension)

```sh
sudo ufw enable

sudo ufw allow OpenSSH

sudo apt install nginx
sudo ufw allow 'Nginx Full'

sudo apt install python3-pip python3-dev libpq-dev postgresql postgresql-contrib nginx gunicorn curl



sudo apt update
sudo apt install pipx
pipx ensurepath

pipx install poetry
# source shell
poetry install

poetry run python manage.py makemigrations
poetry run python manage.py migrate

sudo vim /etc/systemd/system/gunicorn.socket


```
