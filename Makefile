.PHONY: lint sqlite

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

render:
	raco pollen render pollen

reset:
	raco pollen reset

zap:
	find pollen -name "*.html" -type f -delete
	find pollen -name "temp" -type d -exec rm -rf {} +
	make reset

render-from-scratch:
	make zap
	make render

run:
	raco chief start

pollen-server:
	raco chief start -f Procfile.preprocess


sqlite:
	mkdir -p sqlite
	racket scripts/make-db.rkt

zap-sqlite:
	find . -name "*.sqlite" -type f -delete
	make sqlite

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