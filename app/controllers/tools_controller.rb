class ToolsController < ApplicationController
    def index
        user = ::TwitterClient.instance.user("LucySuddenly")
        render json: user
    end
end
