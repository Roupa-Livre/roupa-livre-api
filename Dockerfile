FROM ruby:2.2.4-alpine

LABEL maintainer="Nucleo <dev@nucleo.house>"

RUN apk update && \
    apk add build-base nodejs postgresql-dev zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev && \
    apk add --no-cache --virtual .ruby-gemdeps libc-dev gcc libxml2-dev libxslt-dev make file file-dev && \
    mkdir /app

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle config build.nokogiri --use-system-libraries && bundle install --binstubs

COPY . .