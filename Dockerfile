FROM ruby:2.7

COPY . .
RUN bundle install

EXPOSE 3000
CMD /usr/local/bin/ruby web_server.rb
