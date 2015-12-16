class Api::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :require_login
  before_action :restrict_access

  private

	  def restrict_access
	    if request.method != "OPTIONS"
	      authenticate_or_request_with_http_token do |token, options|
          @current_store = Store.find_by(auth_token: token) if token
        end
	    end
	  end

end
