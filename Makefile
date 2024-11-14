.PHONY: format sqlite render

# TODO: override default-omitted-path? to ignore sqlite and static folders https://docs.racket-lang.org/pollen/raco-pollen.html#(part._raco_pollen_render)

render:
ifndef FILE
	@echo "Error: Please specify a file with FILE=<filename>"
	@echo "Example: make render FILE=index.html.pm"
else
	cd content && YES=blah raco pollen render $(FILE)
endif

render-book:
	cd content && latexmk -pdf wholebook.tex

render-all: render-html render-tex render-pdf

render-html: 
	cd content && raco pollen render --target html --recursive

# TODO: for some reason, combining target and recursive doesn't work
# this renders both HTML and PDF
render-tex:
	cd content && raco pollen render --target tex --recursive

render-pdf: render-book
	cd content && raco pollen render --target pdf --recursive

xrefs:
	cd content && POLLEN=generate-xrefs raco pollen render . && POLLEN=generate-xrefs raco pollen render lesson

reset:
	cd content && raco pollen reset

zap:
	find content -name "*.html" -type f -delete
	find content -name "*.pdf" -type f -delete
	make reset

# https://mg.readthedocs.io/latexmk.html
# TODO: latexmk -c is better for cleaning
zap-latex:
	find . -name "*.pdf" -type f -delete
	find . -name "*.aux" -type f -delete
	find . -name "*.log" -type f -delete
	find . -name "*.out" -type f -delete
	find . -name "*.bcf" -type f -delete
	find . -name "*.bib" -type f -delete
	find . -name "*.run.xml" -type f -delete
	find . -name "*.toc" -type f -delete
	find . -name "*.fdb_latexmk" -type f -delete
	find . -name "*.fls" -type f -delete

# this is just to remind me that latexmk exists
# don't forget about latexmk -pdf -pvc!!! (preview continuously)
latex:
	latexmk -pdf main.tex

run:
	raco chief start

build-css:
	pnpm run build:css

pollen-server:
	cd content && raco pollen start . 8081

publish:
	cd content && raco pollen publish . ../out

sqlite:
	mkdir -p sqlite
	racket scripts/make-db.rkt

zap-sqlite:
	find . -name "*.sqlite" -type f -delete
	make sqlite

format:
	@echo "Searching for Git repositories and formatting Racket files with uncommitted changes..."
	@find . -type d -name .git -prune | while read -r gitdir; do \
		repodir="$$(dirname "$$gitdir")"; \
		echo "\nProcessing repository in $$repodir"; \
		cd "$$repodir" || continue; \
		git status --porcelain | grep '\.rkt$$' | awk '{print $$2}' | while read -r file; do \
			echo "Formatting \"$$file\"..."; \
			if [ -f "$$file" ]; then \
				if raco fmt -i "$$file"; then \
					echo "Successfully formatted \"$$file\""; \
				else \
					echo "Failed on \"$$file\""; \
					exit 1; \
				fi; \
			fi; \
		done; \
		cd - > /dev/null; \
	done
	@echo "\nFormatting complete."

lint:
	@echo "Searching for Git repositories and linting Racket files with uncommitted changes..."
	@find . -type d -name .git -prune | while read -r gitdir; do \
		repodir="$$(dirname "$$gitdir")"; \
		echo "\nProcessing repository in $$repodir"; \
		cd "$$repodir" || continue; \
		git status --porcelain | grep '\.rkt$$' | awk '{print $$2}' | while read -r file; do \
			if [ -f "$$file" ]; then \
				if raco review "$$file"; then \
					:; \
				else \
					echo "Failed on \"$$file\""; \
					echo ""; \
				fi; \
			fi; \
		done; \
		cd - > /dev/null; \
	done
	@echo "\nLinting complete."

refactor:
	@echo "Searching for Git repositories and refactoring Racket files with uncommitted changes..."
	@find . -type d -name .git -prune | while read -r gitdir; do \
		repodir="$$(dirname "$$gitdir")"; \
		echo "\nProcessing repository in $$repodir"; \
		cd "$$repodir" || continue; \
		git status --porcelain | grep '\.rkt$$' | awk '{print $$2}' | while read -r file; do \
			echo "Refactoring \"$$file\"..."; \
			if [ -f "$$file" ]; then \
				if resyntax fix --file "$$file"; then \
					echo "Successfully refactored \"$$file\""; \
				else \
					echo "Failed on \"$$file\""; \
					exit 1; \
				fi; \
			fi; \
		done; \
		cd - > /dev/null; \
	done
	@echo "\nRefactor complete."
	make format