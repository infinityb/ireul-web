source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt'

# Use Unicorn as the app server
# gem 'unicorn'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rspec-mocks'
  gem 'sqlite3'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'rubocop'
  gem 'capistrano-rails'
  gem 'capistrano-passenger'
end

group :test do
  # Required for Travis CI
  gem 'rake'
end

group :production do
  gem 'pg'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Windows compatability requirement
gem 'nokogiri', '>= 1.6.7'

gem 'react-rails', '~> 1.6.0'
gem 'paperclip', '~> 4.3'
gem 'kaminari'

gem 'ogg', '0.0.5', git: 'https://github.com/infinityb/ruby-ogg.git'

# Own fork of ireul ruby client, at least until it's its own repo/published
# Bundler had a problem with finding the correct path for the gemspec
gem 'ireul', '0.0.5', git: 'https://github.com/gyng/ireul.git', branch: 'gemspec'
