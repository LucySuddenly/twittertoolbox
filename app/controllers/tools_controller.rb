class ToolsController < ApplicationController
  after_action :json_log

  def user
    @response = TwitterClient.instance.user(params[:user]).to_h
    render json: @response
  end

  def followers
    # TODO: abstract paging logic in module method

    user = params[:user]
    options = {
        count: 200, 
        skip_status: true,
        include_user_entities: false
      }

    # https://developer.twitter.com/en/docs/twitter-api/v1/accounts-and-users/follow-search-get-users/api-reference/get-followers-list
    response = TwitterClient.instance.followers(user, options).to_h

    if response[:next_cursor].nil? 
      @response = response[:users]
      return render json: @response
    end

    collection = Array.new(response[:users])

    requests_made = 1

    # until there is no next cursor or we hit the rate limit
    until response[:next_cursor].nil? || requests_made == 15 do
      options[:cursor] = response[:next_cursor]

      response = TwitterClient.instance.followers(user, options).to_h
      collection.concat(response[:users])
      
      requests_made += 1
    end

    @response = collection
    render json: @response
  end

  def favorites
    @response = TwitterClient.instance.favorites(params[:user]).to_h

    render json: @response
  end

  private

  def json_log
    JsonLogs.write(@response)
  end
end
