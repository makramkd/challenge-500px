class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def hello
    # get access token first
    access_token = get_access_token
    # make a quick api request for one image
    response = make_api_request(access_token,
                                "/photos?feature=fresh_today&sort=created_at&rpp=1&image_size=3&include_store=store_download&include_states=voted")
    render text: response
  end
end
