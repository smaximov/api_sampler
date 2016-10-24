# ApiSampler

[![Build Status](https://travis-ci.org/smaximov/api_sampler.svg?branch=master)](https://travis-ci.org/smaximov/api_sampler)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://www.rubydoc.info/github/smaximov/api_sampler/master)
[![Inline docs](http://inch-ci.org/github/smaximov/api_sampler.svg?branch=master)](http://inch-ci.org/github/smaximov/api_sampler)

Collect samples (request/response pairs) for API endpoints of your Rails app.

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'api_sampler'
```

And then execute:

``` bash
$ bundle install
```

Next, you need to run the generator:

``` bash
$ rails generate api_sampler:install
```

## Usage

How to use my plugin.

## Contributing

Contribution directions go here.

## Testing

`api_sampler` is bundled with a dummy Rails app, which uses the `:postgresql` database adapter.

### Setup

First, you need to create a database role corresponding to your user (if it doesn't exist yet):

``` bash
$ sudo -u postgres createuser $USER --login --createdb
```

Alternatively, you may specify the database role and password using environment variables
`API_SAMPLER_DB_USERNAME` and `API_SAMPLER_DB_PASSWORD`.

Finally, setup the testing database and schema:

``` bash
$ bundle exec rake db:setup RAILS_ENV=test
```

### Running tests

Execute the following commands to run tests:

``` bash
$ bundle exec rake spec         # RSpec tests
$ bundle exec rake yard:doctest # YARD documentation tests
```

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
