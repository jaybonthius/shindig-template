.PHONY: lint sqlite

render:
	cd content && raco pollen render . && raco pollen render lesson

generate-xrefs:
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
	cd content && raco pollen setup -p && raco pollen start . 8081

sqlite:
	mkdir -p sqlite
	racket scripts/make-db.rkt

zap-sqlite:
	find . -name "*.sqlite" -type f -delete
	make sqlite

lint:
	@echo "Linting Racket files..."
	@find . -name "*.rkt" | while read -r file; do \
		if raco fmt -i "$$file"; then \
			echo "Successfully formatted \"$$file\""; \
		else \
			echo "Failed on \"$$file\""; \
			exit 1; \
		fi; \
	done
	@echo "Linting complete."

refactor:
	@echo "Refactoring Racket files..."
	@find . -name "*.rkt" | while read -r file; do \
		if resyntax fix --file "$$file"; then \
			echo "Successfully refactored \"$$file\""; \
		else \
			echo "Failed on \"$$file\""; \
			exit 1; \
		fi; \
	done
	@echo "Refactor complete."
	make lint