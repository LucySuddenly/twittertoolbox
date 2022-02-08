require 'singleton'

class TwitterClient
  include Singleton

  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key    = Rails.application.credentials[:TWITTER][:API_KEY]
      config.consumer_secret = Rails.application.credentials[:TWITTER][:API_KEY_SECRET]
      config.bearer_token    = Rails.application.credentials[:TWITTER][:BEARER_TOKEN]
    end
  end

  # lol I don't want to reimplement anything
  # but eventually I'll probably replace the twitter gem so 
  # why get verbose during prototyping? 😌
  def method_missing(m, *args, &block)
    client.send(m, *args, &block)
  end
end