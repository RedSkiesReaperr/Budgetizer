FROM ruby:3.2.2-alpine

ARG RAILS_MASTER_KEY

# Install system dependencies
RUN apk add --no-cache \
    build-base \
    postgresql

# Configure environment
ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_MASTER_KEY=$RAILS_MASTER_KEY

# Configure bundler
RUN bundle config --global frozen 1
RUN bundle config set --local without 'development test'

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

ENTRYPOINT ["./entrypoint.sh" ]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]