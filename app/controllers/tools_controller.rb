class ToolsController < ApplicationController
    def user
        user = TwitterClient.instance.user(params[:user])

        JsonLogs.write(user)
        render json: user
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
            JsonLogs.write(response)
            return render json: response[:users]
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

        JsonLogs.instance.write(collection)
        render json: collection
    end

    def favorites
        favorites = TwitterClient.instance.favorites(params[:user])

        JsonLogs.write(favorites)
        render json: favorites
    end
end
