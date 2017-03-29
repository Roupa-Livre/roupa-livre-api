source 'https://rubygems.org'

ruby ENV['CUSTOM_RUBY_VERSION'] || '2.2.4'
gem 'rails', '4.2.5'
gem 'rails-api'
gem 'active_model_serializers' , "0.10.0.rc4"
gem 'rack-cors'
gem 'actionmailer'

gem "paranoia", "~> 2.2"
gem 'devise'
gem 'devise_token_auth'
gem 'devise_invitable', '~> 1.3.4'
gem 'carrierwave'
gem 'carrierwave-aws'
gem 'carrierwave_backgrounder'
gem 'kaminari'
gem 'api-pagination'

gem 'tzinfo-data', platforms: [:mswin, :mingw, :jruby, :x64_mingw]

gem 'geokit-rails'

# workers
gem 'slim'
gem 'puma'
gem 'realtime'
gem 'redis'
gem 'redis-namespace'

#social
gem 'omniauth'
gem 'omniauth-facebook', '~> 4.0.0'
gem 'omniauth-instagram'
gem 'omniauth-twitter'
gem 'omniauth-linkedin'
gem 'omniauth-google-oauth2'
# gem 'twitter'
# gem 'instagram'
# gem 'google-api-client', require: 'google/api_client'

gem "aws-ses", "~> 0.6.0", :require => 'aws/ses'

gem 'rollbar', '~> 2.12.0'

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

group :development do
  gem 'annotate', '>=2.6.0'
  gem 'spring'
  gem 'letter_opener'
end
