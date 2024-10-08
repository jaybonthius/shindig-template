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

run:
	raco chief start

run-formatter:
	raco chief start -f Procfile.preprocess

# refactor: 
# 	/home/jay/.local/share/racket/8.14/bin/resyntax 