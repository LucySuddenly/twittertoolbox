require 'singleton'

class TwitterClient
  include Singleton

  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key    = credentials[:API_KEY]
      config.consumer_secret = credentials[:API_KEY_SECRET]
      config.bearer_token    = credentials[:BEARER_TOKEN]
    end
  end

  def method_missing(m, *args, &block)
    client.send(m, *args, &block)
  end

  private

  def credentials
    @credentials ||= Rails.application.credentials.TWITTER
  end
end