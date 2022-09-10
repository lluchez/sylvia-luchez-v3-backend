# Usage (local)
# docker build -t sylvia-backend \
#  --build-arg RAILS_ENV=<env> \
#  --build-arg RACK_ENV=<env> \
#  .

# Base image
FROM ruby:3.0.4

ENV APP_HOME /app
WORKDIR $APP_HOME

RUN apt-get update -yqq &&\
    apt-get install -yqq --no-install-recommends \
    apt-transport-https

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - &&\
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - &&\
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
    tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -yqq &&\
    apt-get install -yqq --no-install-recommends \
    apt-utils \
    nodejs \
    yarn \
    vim

COPY Gemfile* $APP_HOME/
COPY .ruby-version $APP_HOME/
RUN bundle install

COPY . $APP_HOME
