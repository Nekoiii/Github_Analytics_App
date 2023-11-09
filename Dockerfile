FROM ruby:3.1

ARG RUBYGEMS_VERSION=3.4.6

RUN mkdir /api
WORKDIR /api


RUN gem update --system ${RUBYGEMS_VERSION}

RUN apt-get update && apt-get install -y cron
RUN service cron start

COPY Gemfile Gemfile.lock /api/

RUN bundle install


COPY . /api

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["rails", "server", "-b", "0.0.0.0"]
