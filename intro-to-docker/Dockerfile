FROM ruby:2.2

EXPOSE 5000

CMD ruby -run -e httpd -- -p 5000 .
# RUN \
#   apt-get update && apt-get install -y --no-install-recommends \
#     postgresql-client && \
#   rm -rf /var/lib/apt/lists/*

# RUN mkdir -p /usr/src/app
# WORKDIR /usr/src/app

# COPY Gemfile* /usr/src/app/
# RUN bundle install

# EXPOSE 3000

# COPY . /usr/src/app

# CMD ["rails", "server", "-b", "0.0.0.0"]
