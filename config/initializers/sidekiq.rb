Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://10.0.5.184:6379/12' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://10.0.5.184:6379/12' }
end