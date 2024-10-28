.PHONY: format sqlite

render:
	cd content && raco pollen render -r

xrefs:
	cd content && POLLEN=generate-xrefs raco pollen render . && POLLEN=generate-xrefs raco pollen render lesson

reset:
	cd content && raco pollen reset

zap:
	find content -name "*.html" -type f -delete
	find content -name "temp" -type d -exec rm -rf {} +
	make reset

run:
	raco chief start

pollen-server:
	cd content && raco pollen start . 8081

publish:
	raco pollen publish content out

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