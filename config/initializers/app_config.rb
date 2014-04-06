Rails.configuration.refresh_interval_in_seconds = 2.minutes.to_i

Rails.configuration.http_auth_username = ENV['HTTP_AUTH_USERNAME']
Rails.configuration.http_auth_password = ENV['HTTP_AUTH_PASSWORD']
