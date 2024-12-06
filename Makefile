.PHONY: format sqlite render

# TODO: override default-omitted-path? to ignore sqlite and static folders https://docs.racket-lang.org/pollen/raco-pollen.html#(part._raco_pollen_render)

render:
ifndef FILE
	@echo "Error: Please specify a file with FILE=<filename>"
	@echo "Example: make render FILE=index.html.pm"
else
	cd content && YES=blah raco pollen render $(FILE)
endif

render-all: render-html render-tex render-pdf

render-html: 
	cd content && raco pollen render --target html index.ptree && raco pollen render --force backmatter/book-index.html

render-tex:
	cd content && raco pollen render tex.ptree && raco pollen render wholebook.tex handouts.tex

render-pdf: render-handouts
	cd content && raco pollen render --target pdf pdf.ptree

render-handouts: render-tex
	cd content && latexmk -pdf handouts.tex

render-wholebook: render-tex
	cd content && latexmk -pdf wholebook.tex

pagetree: 
	racket scripts/make-pagetree.rkt

xrefs:
	cd content && POLLEN=generate-xrefs raco pollen render . && POLLEN=generate-xrefs raco pollen render lesson

clean: reset zap

reset:
	cd content && raco pollen reset

zap: zap-html zap-tex zap-pdf zap-sqlite

zap-html:
	find content -name "*.html" -type f -delete

zap-pdf:
	find content -name "*.pdf" -type f -delete

zap-tex:
	find content -name "*.tex" -type f -delete
	find content -name "*.aux" -type f -delete
	find content -name "*.log" -type f -delete
	find content -name "*.out" -type f -delete
	find content -name "*.bcf" -type f -delete
	find content -name "*.bib" -type f -delete
	find content -name "*.run.xml" -type f -delete
	find content -name "*.toc" -type f -delete
	find content -name "*.fdb_latexmk" -type f -delete
	find content -name "*.fls" -type f -delete

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