require 'singleton'

class TwitterClient
  include Singleton

  CURSOR_KEYS = [
    "next_cursor",
    "next_cursor_str",
    "previous_cursor",
    "previous_cursor_str"
  ].freeze

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

  # not sure about this name yet, it doesn't sit right. bad vibes
  def get_resource_with_cursor(resource, user, options, rate_limit)
    response = client.send(resource, user, options).to_h

    # determine the key which points to the collection for the resource
    collection_name = (response.keys - CURSOR_KEYS)[0].to_sym

    if response[:next_cursor].nil? 
      @response = response[collection_name]
      return render json: @response
    end

    collection = Array.new(response[collection_name])

    requests_made = 1

    # until there is no next cursor or we hit the rate limit
    # TODO: need better rate limit respect logic 
    until response[:next_cursor].nil? || requests_made == rate_limit do
      options[:cursor] = response[:next_cursor]

      response = client.send(resource, user, options).to_h
      collection.concat(response[collection_name])
      
      requests_made += 1
    end

    collection
  end
end