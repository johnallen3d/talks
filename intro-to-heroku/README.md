# Intro to Heroku

## Overview

* [Platform as a Service](https://en.wikipedia.org/wiki/Platform_as_a_service) (PaaS)
  vs AWS [Infrastructure as a Service](https://en.wikipedia.org/wiki/Cloud_computing#Infrastructure_as_a_service_.28IaaS.29) (IaaS)

    * Fully managed app deployment and hosting
    * Developers focus on building apps not maintaining servers
    * Drag a slider scaling (options for automation)
    * Large add-on ecosystem (databases etc)
    * Increase database size with click of a button

* Founded ~10 years ago with support for Rails
* Purchased by SalesForce in 2010

## Notes

* Releases - painless rollback
* Logging - support for writing to remote sys/http logs, allows for log aggregation
* SSL - by default and FREE (Server Name Indication - SNI)
* Review apps
* Preboot (zero downtime deployments)
* Built in metrics
* Add-on ecosystem
* Automated deployments
* Scaling - Web interface, CLI, Automatically via metrics
* Container Registry and Runtime (Docker - beta)

## Example

### Sample Rails Application

Steps ripped from [`docker-compose` documentation](https://docs.docker.com/compose/rails/)

```sh
mkdir sample-app
cd sample-app
```

```Dockerfile
FROM rails:latest
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
ADD . /myapp
```

```Gemfile
source 'https://rubygems.org'
gem 'rails', '5.0.1'
```

```sh
touch Gemfile.lock
```

```yaml
# docker-compose.yml
version: '2'
services:
  db:
    image: postgres:alpine
  web:
    build: .
    command: bundle exec rails s -p 3000 -b '0.0.0.0'
    volumes:
      - .:/myapp
    ports:
      - "3000:3000"
    depends_on:
      - db
```

```sh
docker-compose run web rails new . --force --database=postgresql --skip-bundle
```

```yaml
# config/database.yml
development: &default
  adapter: postgresql
  encoding: unicode
  database: myapp_development
  pool: 5
  username: postgres
  password:
  host: db
```

```html
<!-- app/views/pages/home.html.erb -->
<h2>KF Blog!</h2>

<p>Welcome to the wonderful world of KF!</p>
```

```ruby
# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  def show
    render template: "pages/#{params[:page]}"
  end
end
```

```ruby
# config/routes.rb
  get "/pages/:page" => "pages#show"
  root "pages#show", page: "home"
```

```sh
docker-compose run web rake db:create
docker-compose up
open http://localhost:3000
```

### Create Heroku App

Steps ripped from [Heroku documentation](https://devcenter.heroku.com/articles/git)

```sh
git init
git add .
git commit -m "my first commit"
heroku create kf-blog
git push heroku master
heroku open
```

### Add Blog Feature

```sh
docker-compose run web rails g scaffold blog title:string body:text
docker-compose run web rails db:migrate
```

```ruby
# app/views/pages/home.html.erb
<%= link_to 'my blog', :blogs %>
```

```sh
docker-compose up
```

```
# Procfile
web: puma
release: rake db:migrate
```

```sh
git add .
git commit -m "added my blog"
git push heroku master
heroku open
```

### Setup Addons

#### Increase database size

Steps ripped from [Heroku documentation](https://devcenter.heroku.com/articles/upgrading-heroku-postgres-databases=)

```sh
heroku addons:create heroku-postgresql:hobby-basic
export UPGRADED_DB_NAME=HEROKU_POSTGRESQL_PINK_URL
heroku maintenance:on
heroku open
heroku pg:copy DATABASE_URL $UPGRADED_DB_NAME --confirm kf-blog
heroku pg:promote $UPGRADED_DB_NAME
heroku maintenance:off
heroku open
```

#### Add Log Aggregator

Install Papertrail add-on

```sh
heroku addons:create papertrail
```

### Scale the application

```sh
heroku ps:resize web=standard-1x
heroku scale web=2
heroku open
heroku logs --tail
# visit papertrail
open https://dashboard.heroku.com/apps/kf-blog
```

### Tear Down Application

```sh
heroku apps:delete
```
