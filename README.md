# ApiSampler

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

Then, you need to setup the testing database and schema:

``` bash
$ rake app:db:test:prepare
$ rake app:db:migrate
```

### Running tests

Execute the following command to run tests:

``` bash
$ rake spec
```

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
