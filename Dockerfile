# Use the official Racket image as base
FROM racket/racket:8.10

# Set working directory
WORKDIR /app

# Copy your shindig package and pollen config first
COPY shindig/ ./shindig/
COPY pollen.rkt ./

# Install shindig package which includes pollen as a dependency
RUN raco pkg install --auto shindig/

# Copy content directory
COPY content/ ./content/

# Show contents for debugging
RUN ls -la && \
    echo "Content directory:" && \
    ls -la content/ && \
    echo "Shindig package:" && \
    ls -la shindig/

# Build the site
RUN cd content && \
    raco pollen render && \
    raco pollen publish && \
    cd ..

# Verify the built contents
RUN echo "Final content directory:" && \
    ls -la content/