# nib plugins

## nib

* [`nib`](https://github.com/technekes/nib) is a convenience wrapper for `docker-compose`
* originally designed with Ruby/Rails developers in mind but has features that would be helpful for any developer

## Plugin Architecture

### Background

* Requested features did not necessarily fit in the core `nib` code base
* Some features might be very specific to a Technekes workflow

[link](https://github.com/technekes/nib/issues/133)

### Discovery Design

* Requirements: little/no configuration, easy to install and implement, core commands overridable
* Approach borrowed from [minitest](http://www.monkeyandcrow.com/blog/reading_ruby_minitest_plugin_system/)
* Use RubyGems to search the file system for potential plugins
* Allow the plugin to "self select"

[link](https://github.com/technekes/nib/commit/1e76f38d5a7b56113a2ef3251e8c65bf1c059e59)

## Plugin Implementation

There are three requirements for a `nib` plugin:

1. A Ruby gem that relies on [gli](https://github.com/davetron5000/gli) for defining it's CLI interface following the naming convention `bin/nib-*`
1. It puts a file on the `LOAD_PATH` that ends with `_plugin.rb` following the naming convention `./lib/nib_*_plugin.rb`
1. Implements `.applies?`, which allows the plugin to "self-select" (ie. was the command was run in what appears to be an applicable project)

### Plugin Example

As an example let's define a plugin for `nib` that caters to Ruby developers.

```ruby
# ./bin/nib-echo

#!/usr/bin/env ruby

desc 'Say hello nib-echo'
arg :text, %i(multiple)
command :echo do |c|
  c.action do |_global_options, _options, args|
    puts args.join(' ')
  end
end
```

```ruby
# ./lib/nib_echo_plugin.rb

module Nib
  module Echo
    def self.applies?
      # echo always applies!
      true
    end
  end
end
```

```ruby
# ./nib-echo.gemspec

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
...
```

If nib-echo has been installed and a `nib` command is run it will append gli commands from `bin/nib-echo`.

[docs](https://github.com/technekes/nib#plugins)

## Existing Plugins

### nib-crypt

Opinionated secrets management.

* Create an encryption key for a project (directory) and push it to an S3 bucket (requires environment variable)
* Pull an encryption key from an S3 bucket for an existing project
* Convenience wrappers around encryption and decryption (uses `openssl` and before mentioned key)

```text
COMMANDS
    ...
    crypt-init  - Initialize a project (create or pull secret key)
    ...
    decrypt     - Decrypt a file
    encrypt     - Encrypt a file
    ...
```

[link](https://github.com/technekes/nib-crypt)

### nib-heroku

Integrates commands with Heroku

* Uses the directory name to infer a Heroku application name (following Technekes convention)
* Accepts an environment flag
* If non-development environment flag is specified will shell out to [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) to integrate a shell session or logs

```text
COMMANDS
    ...
    logs        - Access logs for the speified service or Heroku application
    ...
    shell       - Start a shell session in a one-off service container
    ...
```

[link](https://github.com/technekes/nib-heroku)

## Live Demo

Let's create `nib-echo`!

![](https://media.tenor.com/images/1eb004b3529fb82d65cebffae7d4dce6/tenor.gif)

```sh
# fire up a Ruby container
docker run --rm -it -v $PWD:$PWD -w $PWD ruby:alpine ash

# scaffold a new gem
bundle gem --test=none --mit --no-coc --bin nib-echo
cd nib-echo

# update nib-echo.gemspec (simplified version)
echo "
\$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

Gem::Specification.new do |spec|
  spec.name    = 'nib-echo'
  spec.version = '0.1.0'
  spec.summary = 'nib-echo'
  spec.authors = ['John']

  spec.files         = Dir['lib/**/*.rb']
  spec.require_paths = ['lib']
  spec.bindir        = 'bin'
  spec.executables   = ['nib-echo']

  spec.add_runtime_dependency 'nib', '>= 2.0'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
end
" > nib-echo.gemspec

# nib currently expect bin/nib-echo but bundler creates exe/nib-echo
rm -rf exe

# edit the executable
echo "
#!/usr/bin/env ruby

desc 'Say hello nib-echo'
arg :text, %i(multiple)
command :echo do |c|
  c.action do |_global_options, _options, args|
    puts args.join(' ')
  end
end
" > bin/nib-echo

# create plugin detection file
echo "
module Nib
  module Echo
    def self.applies?
      # echo always applies!
      true
    end
  end
end
" > lib/nib_echo_plugin.rb

# build the gem
rake build

# exit the docker container
exit

# install the gem
gem install nib-echo/pkg/nib-echo-0.1.0.gem

# does it work?! 🤞
nib help
nib echo hello world
```
