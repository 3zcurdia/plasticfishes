# Phase 1: Build phase
FROM ruby:3.3.0 AS builder
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

# Phase 2: Execution phase
FROM ruby:3.3.0
WORKDIR /app
COPY --from=builder /app .
ARG PORT
EXPOSE $PORT

# Start the application with rackup
CMD ["rackup", "--server", "puma", "-p", "$PORT"]
