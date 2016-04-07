source 'https://rubygems.org'

ruby ENV['CUSTOM_RUBY_VERSION'] || '2.2.4'
gem 'rails', '4.2.5'
gem 'rails-api'
gem 'rack-cors'
gem 'actionmailer'
gem 'devise'
gem 'omniauth'
gem 'devise_token_auth'
gem 'devise_invitable', '~> 1.3.4'
gem 'carrierwave'
gem 'carrierwave-aws'
gem 'carrierwave_backgrounder'
gem 'kaminari'
gem 'api-pagination'
gem 'tzinfo-data', platforms: [:mswin, :mingw, :jruby, :x64_mingw]
group :database do
group :postgresql do
  gem 'pg'
end

end

group :workers do
  gem 'sidekiq', '~> 3.2.6'
  gem 'redis'
  gem 'redis-namespace'
end

group :android do
  gem 'gcm'
end

group :logging do
  gem 'google-analytics-rails'
  gem 'rollbar', '~> 2.2.1'
end

group :development do
  gem 'annotate', '>=2.6.0'
  gem 'spring'
  gem 'letter_opener'
end
