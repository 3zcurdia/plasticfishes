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
ENV RACK_ENV=production
ENV RUBY_YJIT_ENABLE=1
EXPOSE $PORT

# Start the application with rackup
CMD ["rackup", "--server", "falcon", "-p", "$PORT"]
