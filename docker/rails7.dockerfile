# Use official Ruby base image (Debian-based)
FROM ruby:3.2

# Set working directory
WORKDIR /app

# Install OS-level dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    default-mysql-client \
    curl \
    gnupg \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (needed for Rails assets)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get update -qq \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Yarn (without using deprecated apt-key)
RUN mkdir -p /etc/apt/keyrings \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor > /etc/apt/keyrings/yarn.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian stable main" \
       | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -y yarn \
    && rm -rf /var/lib/apt/lists/*

# Copy Gemfile(s) first for caching
COPY Gemfile* ./

# Install gems
RUN gem uninstall stringio -a || true \
    && bundle install

# Copy the rest of the app
COPY . .

# Expose Rails server port
EXPOSE 3000

# Safe entrypoint: create app only if missing
CMD if [ ! -f config/application.rb ]; then \
      echo "⚡ Generating new Rails app..."; \
      rails new . -d mysql --skip-bundle; \
      bundle install; \
      rails db:create db:migrate; \
    else \
      echo "✅ Rails app already exists, skipping new project generation"; \
    fi && rails server -b 0.0.0.0


# Start Rails server
CMD ["bash", "-c", "bundle exec rails s -b 0.0.0.0 -p 3000"]