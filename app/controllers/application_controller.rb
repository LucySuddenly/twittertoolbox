class ApplicationController < ActionController::API
  around_action :catch_twitter_errors
  after_action :json_log

  private

  def json_log
    JsonLogs.write(@response)
  end

  def catch_twitter_errors
    begin
      yield
    rescue Twitter::Error => e
      @response = "Eep! Twitter returned an error: #{e.message}"
      json_log
      
      render plain: @response, status: e.class.to_s.split("::")[2].underscore.to_sym 
      # lol why am I using a gem that doesn't return codes in the errors??
      # the method chain above should usually work: https://github.com/sferik/twitter/blob/master/lib/twitter/error.rb#L77-L90
      # but when I get to POSTing back to twitter this will need more complexity
    end
  end
end
