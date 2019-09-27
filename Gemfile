source 'https://rubygems.org'

ruby '2.2.4'
gem 'rails', '4.2.5'
gem 'rails-api'
gem 'active_model_serializers' , "0.10.0.rc4"
gem 'rack-cors'
gem 'actionmailer'
gem 'sprockets', '~>3.7.2'
# gem 'ruby-filemagic', '~> 0.7.2'
gem 'migration_data'

gem "paranoia", "~> 2.2"
gem 'devise', '3.5.6'
gem 'devise_token_auth', '1.1.0'
gem 'carrierwave'
gem 'carrierwave-aws'
gem 'carrierwave_backgrounder'
gem 'kaminari'
gem 'api-pagination'

gem 'tzinfo-data', platforms: [:mswin, :mingw, :jruby, :x64_mingw]

gem 'geokit-rails'

# workers
gem 'realtime'
gem 'sinatra'
gem 'redis'
gem 'redis-namespace'
gem 'sidekiq', '~> 3.2.6'

#social
gem 'omniauth'
gem 'omniauth-facebook', '~> 5.0.0'
gem 'omniauth-instagram'
gem 'omniauth-twitter'
gem 'omniauth-linkedin'
gem 'omniauth-google-oauth2'
# gem 'twitter'
# gem 'instagram'
# gem 'google-api-client', require: 'google/api_client'

gem 'slim'

gem "aws-ses", "~> 0.6.0", :require => 'aws/ses'

gem 'rollbar', '~> 2.12.0'
gem 'wet-health_endpoint'

group :database do
  group :postgresql do
    gem 'pg'
  end
end

group :android do
  gem 'fcm'
end

group :ios do
  gem 'grocer'
end

group :logging do
  gem 'google-analytics-rails'
end

gem 'figaro'
gem 'puma'

group :development do
  gem 'annotate', '>=2.6.0'
  gem 'spring', '>=1.5.0'
  gem 'letter_opener'

  gem 'capistrano', '3.4.0'
  gem 'capistrano3-puma'
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rvm'
  gem 'capistrano-rails-console', require: false
  gem 'capistrano-rake', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano-rails-tail-log'
end
