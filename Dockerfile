# Use the official Racket image as base
FROM racket/racket:8.14

# Set working directory
WORKDIR /app

# Copy your shindig package and pollen config first
COPY shindig/ ./shindig/
COPY pollen.rkt ./

# Install shindig package which includes pollen as a dependency
RUN raco pkg install --auto shindig/

# Copy content directory
COPY content/ ./content/
COPY sqlite/ ./sqlite/

# Show contents for debugging
RUN ls -la && \
    echo "Content directory:" && \
    ls -la content/ && \
    echo "Shindig package:" && \
    ls -la shindig/

# Build the site
RUN raco pollen render -r content && \
    raco pollen publish content out

# Verify the built contents
RUN echo "Final content directory:" && \
    ls -la content/