FROM ruby:3.1-slim

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    libyaml-dev \
    git \
    curl \
    && apt-get clean

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle install -j4

COPY . /app

EXPOSE 3003

CMD ["rails", "s", "-b", "0.0.0.0"]