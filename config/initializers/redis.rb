uriRedis = ENV["REDISTOGO_URL"] ? ENV["REDISTOGO_URL"] : 'redis://127.0.0.1:6379'
uri = URI.parse(uriRedis)
REDIS = Redis.new(:url => uriRedis)