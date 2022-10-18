FROM ruby:3.1.2

RUN apt-get update -qq && apt-get install -y postgresql-client
RUN curl https://deb.nodesource.com/setup_16.x | bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y nodejs yarn vim

WORKDIR /usr/src/app

COPY . .
RUN bundle install
RUN gem install foreman

EXPOSE 3000