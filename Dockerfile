FROM ruby:2.2.4-alpine

RUN apk update && apk add build-base nodejs postgresql-dev zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev 
RUN apk add --no-cache --virtual .ruby-gemdeps libc-dev gcc libxml2-dev libxslt-dev make

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install --binstubs

COPY . .

LABEL maintainer="Nucleo <dev@nucleo.house>"

CMD puma -C config/puma.rb