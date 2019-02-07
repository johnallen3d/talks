FROM ruby:2.6-alpine

WORKDIR /usr/src/app

COPY . .

CMD ["ruby", "-run", "-e", "httpd", "--", "-p", "5000", "."]
