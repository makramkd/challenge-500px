require 'json'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def hello
    api_key = Rails.application.secrets.five_consumer_key
    if api_key == nil
      render text: "no api key found"
    else
      render text: api_key
    end
  end
end
