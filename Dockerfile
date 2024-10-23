FROM ruby:3.2.4

RUN mkdir /lesson_board
WORKDIR /lesson_board
COPY Gemfile /lesson_board/Gemfile
COPY Gemfile.lock /lesson_board/Gemfile.lock

RUN gem update --system
RUN bundle update --bundler

RUN apt-get update && apt-get install -y imagemagick

RUN bundle install
COPY . /lesson_board

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
