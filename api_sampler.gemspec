# frozen_string_literal: true
$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'api_sampler/version'

Gem::Specification.new do |s|
  s.name = 'api_sampler'
  s.version = ApiSampler::VERSION
  s.authors = ['smaximov']
  s.email = ['s.b.maximov@gmail.com']
  s.homepage = 'https://github.com/smaximov/api_sampler'
  s.summary = 'Collect samples for API endpoints of your Rails app'
  s.license = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*',
                'MIT-LICENSE', 'Rakefile', 'README.md']

  # Backend
  s.add_dependency 'rails', '~> 5.0.0', '>= 5.0.0.1'

  # Frontend
  s.add_dependency 'autoprefixer-rails', '~> 6.5'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'less-rails-semantic_ui', '~> 2.2'

  # Testing
  s.add_development_dependency 'factory_girl_rails', '~> 4.7.0'
  s.add_development_dependency 'guard-rspec', '~> 4.7.3'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'shoulda-matchers', '~> 3.1.1'
  s.add_development_dependency 'yard-doctest'

  # Dummy app
  s.add_development_dependency 'therubyracer'

  # Misc
  s.add_development_dependency 'yard'
end
