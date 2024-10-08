.PHONY: lint

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
	make zap
	raco pollen render pollen

run:
	raco chief start

pollen-server:
	raco chief start -f Procfile.preprocess

zap:
	find pollen -name "*.html" -type f -delete
	find pollen -name "temp" -type d -exec rm -rf {} +
	raco pollen reset

refactor:
	@echo "Refactoring Racket files..."
	@find . -name "*.rkt" | while read -r file; do \
		if /home/jay/.local/share/racket/8.14/bin/resyntax fix --file "$$file"; then \
			echo "Successfully refactored \"$$file\""; \
		else \
			echo "Failed on \"$$file\""; \
			exit 1; \
		fi; \
	done
	@echo "Refactor complete."
	make lint