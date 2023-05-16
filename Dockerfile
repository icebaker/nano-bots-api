FROM ruby:3.2.2-slim-bullseye AS builder-gems
RUN apt-get update && apt-get install -y --no-install-recommends build-essential libffi-dev lua5.4-dev
RUN bundle config set --local without 'development:test'
ADD ./Gemfile /build/shared/Gemfile
WORKDIR /build/shared
RUN bundle install

FROM ruby:3.2.2-slim-bullseye
RUN apt-get update && apt-get install -y --no-install-recommends git lua5.4-dev
WORKDIR /nano-bots
COPY --from=builder-gems /usr/local/bundle /usr/local/bundle
COPY . /nano-bots
RUN rm /nano-bots/Gemfile.lock
COPY --from=builder-gems /build/shared/Gemfile.lock /nano-bots/Gemfile.lock
RUN rm -rf /nano-bots/.env && touch /nano-bots/.env

USER 1000
RUN bundle config set --local without 'development:test'
WORKDIR /nano-bots
CMD ["bash", "./init.sh"]
