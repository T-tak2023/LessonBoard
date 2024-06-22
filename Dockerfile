FROM ruby:3.2.4

RUN mkdir /lesson_board
WORKDIR /lesson_board
COPY Gemfile /lesson_board/Gemfile
COPY Gemfile.lock /lesson_board/Gemfile.lock

# Bundlerの不具合対策(1)
RUN gem update --system
RUN bundle update --bundler

RUN bundle install
COPY . /lesson_board

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
