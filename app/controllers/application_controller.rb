class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  CONSUMER_KEY = ENV["MYFIVEHUNDRED_CONSUMER_KEY"]
  CONSUMER_SECRET = ENV["MYFIVEHUNDRED_CONSUMER_SECRET"]
  USERNAME = ENV["FIVE_USERNAME"]
  PASSWORD = ENV["FIVE_PASSWORD"]
  BASE_URL = "https://api.500px.com/v1"

  def hello
    # get access token first
    access_token = get_access_token
    # make a quick api request for one image
    response = make_api_request(access_token,
                                "/photos?feature=fresh_today&sort=created_at&rpp=1&image_size=3&include_store=store_download&include_states=voted")
    render text: response
  end

  # create an access token in order to make an api call
  def get_access_token
    # create oauth consumer
    consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, {
        :site               => BASE_URL,
        :request_token_path => "/oauth/request_token",
        :access_token_path  => "/oauth/access_token",
        :authorize_path     => "/oauth/authorize"
    })

    # create request token
    request_token = consumer.get_request_token()

    # create and return access token
    access_token = consumer.get_access_token(request_token, {}, {
        :x_auth_mode => 'client_auth', :x_auth_username => USERNAME, :x_auth_password => PASSWORD
    })

    access_token
  end

  # make an api request and return the json response body
  def make_api_request(access_token, request)
    response_body = access_token.get(request).body
    response_body
  end

  # parse the json in order to get image urls
  def get_image_urls(json_response)
    parsed_json = JSON.parse(json_response)
    photos_json_array = parsed_json["photos"]
    image_url_array = []
    photos_json_array.each { |photo|
      image_url_array << photo["image_url"]
    }

    image_url_array
  end
end
