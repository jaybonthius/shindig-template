.PHONY: format sqlite

# TODO: override default-omitted-path? to ignore sqlite and static folders https://docs.racket-lang.org/pollen/raco-pollen.html#(part._raco_pollen_render)

render: render-html render-pdf

render-html: 
	cd content && raco pollen render --target html --recursive

# TODO: for some reason, combining target and recursive doesn't work
# this renders both HTML and PDF
render-pdf:
	cd content && raco pollen render --target pdf --recursive

xrefs:
	cd content && POLLEN=generate-xrefs raco pollen render . && POLLEN=generate-xrefs raco pollen render lesson

reset:
	cd content && raco pollen reset

zap:
	find content -name "*.html" -type f -delete
	find content -name "*.pdf" -type f -delete
	make reset

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