class ToolsController < ApplicationController
  def user
    @response = TwitterClient.instance.user(params[:user]).to_h
    render json: @response
  end

  def followers
    user = params[:user]
    options = {
        count: 200, 
        skip_status: true,
        include_user_entities: false
      }

    # ~30 sec response time for ~2500 followers
    # awful. filthy. must fix.
    @response = TwitterClient.instance.get_resource_with_cursor(:followers, user, options, 15)
    render json: @response
  end

  def favorites
    @response = TwitterClient.instance.favorites(params[:user]).to_h
    render json: @response
  end
end
