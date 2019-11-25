FROM ruby:2.6 as base

ENV LANG C.UTF-8

RUN apt-get update -qq && \
  apt-get install --no-install-recommends --fix-missing -y \
  build-essential \
  cmake \
  file \
  git \
  libcurl4-openssl-dev \
  libpq-dev \
  libqtwebkit-dev \
  locales \
  pkg-config \
  postgresql-client \
  qt4-qmake \
  curl \
  gnupg2 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN gem update --system 2.7.8
RUN gem install bundler -v 1.17.1
RUN bundle config github.https true

ARG APP_HOME=/app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile $APP_HOME
ADD Gemfile.lock $APP_HOME
RUN bundle install --system

ENV PORT 80
EXPOSE 80

ADD . $APP_HOME

CMD thor app server
