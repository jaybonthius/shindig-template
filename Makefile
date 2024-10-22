.PHONY: lint sqlite

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
	make render
	raco chief start

pollen-server:
	cd content && raco pollen setup -p && raco pollen start . 8081

publish:
	cd content && raco pollen publish .

sqlite:
	mkdir -p sqlite
	racket scripts/make-db.rkt

zap-sqlite:
	find . -name "*.sqlite" -type f -delete
	make sqlite

lint:
	@echo "Linting Racket files with uncommitted changes (staged and unstaged)..."
	@git status --porcelain | grep '\.rkt$$' | awk '{print $$2}' | while read -r file; do \
		echo "Linting \"$$file\"..."; \
		if [ -f "$$file" ]; then \
			if raco fmt -i "$$file"; then \
				echo "Successfully formatted \"$$file\""; \
			else \
				echo "Failed on \"$$file\""; \
				exit 1; \
			fi; \
		fi; \
	done
	@echo "Linting complete."

refactor:
	@echo "Refactoring Racket files with uncommitted changes (staged and unstaged)..."
	@git status --porcelain | grep '\.rkt$$' | awk '{print $$2}' | while read -r file; do \
		echo "Refactoring \"$$file\"..."; \
		if [ -f "$$file" ]; then \
			if resyntax fix --file "$$file"; then \
				echo "Successfully refactored \"$$file\""; \
			else \
				echo "Failed on \"$$file\""; \
				exit 1; \
			fi; \
		fi; \
	done
	@echo "Refactor complete."
	make lint