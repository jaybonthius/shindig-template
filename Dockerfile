# Use the official Racket image as base
FROM racket/racket:8.10

# Install required packages
RUN raco pkg install --auto --no-docs pollen

# Set working directory
WORKDIR /app

# Copy your content directory
COPY content/ ./content/

# Show contents for debugging
RUN ls -la content/

# Build the site with verbose output
RUN raco pollen publish content && echo "Site built successfully!"

# Show the built contents
RUN ls -la content/

# The rendered site will be in content/