# Continuous Integration (CI) and <br/> Continuous Delivery (CD)

[Background reading](https://codeship.com/continuous-integration-essentials)

## CI

Regular automated builds and testing of a code base. We are using [CircleCI](https://circleci.com/docs/2.0/) to facilitate CI (and sometimes CD, see Container Runtime).

```md
GitHub -> CircleCI -> CodeClimate
       \> CodeClimate
```

### Setup

Setup [documentation]().

### Configuration

Example [configuration](https://github.com/technekes/fluxer/blob/master/.circleci/config.yml)

### Container

CircleCI v2.0 runs inside of Docker image/container of your choosing. We have authored an image ([technekes/circleci:latest](https://github.com/technekes/docker-circleci/blob/master/Dockerfile)) that includes Docker Compose allowing for us to run specs in a manner very similar to our development environment.

* docker-compose
* Danger
* nib-crypt (future)

### Test Coverage

Test coverage can be captured by [simplecov](https://rubygems.org/gems/simplecov) while running specs and reported to [CodeClimate](https://docs.codeclimate.com/docs/configuring-test-coverage) for integrations with a repos analysis. Additionally the simplecov output can be stored as a [build artifact CircleCI](https://circleci.com/docs/2.0/artifacts/) ([example](https://circleci.com/gh/technekes/technekes-services-gem/8)).

## CD

Delivering every successful build to staging to allow for acceptance testing. This is not Continuous Deployment which would be delivering each successful build into production.

```md
GitHub -> CircleCI -> Heroku (staging)
```

### Automatic Deploys

A Heroku app can be [configured to deploy automatically](https://devcenter.heroku.com/articles/github-integration#automatic-deploys) when code is pushed to a specified branch and CI passes.

### Preboot

Heroku apps can be [configured for zero downtime deployments by enabling preboot](https://devcenter.heroku.com/articles/preboot). Preboot will deploy new code to a new Dyno, ensure the application boots successfully, and wait for 3 minutes before pointing the load balancer at the new dyno(s).

### Deployment Notifications

Apps on Heroku can deliver deployment notifications to a URL. We use this [feature along with Rollbar](https://rollbar.com/docs/deploys/heroku/) to track deployments and trigger notifications from Rollbar into Slack.

### Logs

Heroku [application and addon logs](https://devcenter.heroku.com/articles/logging) can be accessed via the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli).

```sh
# follow the logs of Fluxer staging
heroku logs -t -a tk-stage-fluxer
# or from a directory named `tk-fluxer`
nib logs -f -e stage
```

### Common Runtime vs Container Runtime

The traditional `git push` deployment on Heroku takes advantage of the [Common Runtime](https://devcenter.heroku.com/articles/dyno-runtime#common-runtime). Recently Heroku has added support for running arbitrary Docker container via the [Container Runtime](https://devcenter.heroku.com/articles/container-registry-and-runtime) (`docker push`).
