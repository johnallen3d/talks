# Intro to Docker

* https://www.docker.com

# Install (OSX)

## Docker Toolbox

https://www.docker.com/products/docker-toolbox

  * docker engine
  * machine
  * compose
  * ~~kitematic~~ : ignore this

## Homebrew

* http://brew.sh

```sh
brew install docker docker-machine docker-compose
```

## Brew Cask

* https://github.com/caskroom/homebrew-cask

```sh
brew cask install dockertoolbox
```

# Docker Machine

* https://docs.docker.com/machine/

## Create Machine

### Default Approach

```sh
docker-machine create default \
  --driver virtualbox \
  --virtualbox-memory 8192 \
  --virtualbox-cpu-count 4 \
  --virtualbox-disk-size 40000
```

### Dinghy

For better performance in file sharing with the host, automated dnsmasq support (*.docker) and filesystem events we recommend trying dinghy.

* https://github.com/codekitchen/dinghy

```sh
brew tap codekitchen/dinghy
brew install dinghy
```

```sh
dinghy create \
  --provider virtualbox \
  --memory=8192 \
  --cpus=4 \
  --disk=40000
```

## Connect to server

```sh
eval $(docker-machine env default)
# or
eval $(dinghy shellinit)
```

# Hello World

```sh
docker run --rm hello-world
```

# Images

* Cleanup
* Dangling

```sh
docker images
```

# Docker Hub

* https://hub.docker.com/explore/

# Docker Compose

* https://docs.docker.com/compose/

# nib

* https://github.com/technekes/nib

# Codeship

* https://codeship.com/documentation/

# ECS

* https://aws.amazon.com/ecs/
