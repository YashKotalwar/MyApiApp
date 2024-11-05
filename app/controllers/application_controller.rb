# class ApplicationController < ActionController::API
#   include ActionController::MimeResponds

#   # Enable session and helper management
#   include ActionController::Helpers
#   include ActionController::Cookies
#   include ActionController::RequestForgeryProtection
#   protect_from_forgery with: :null_session

#   before_action :ensure_json_request
#   before_action :set_session_options
#   before_action :authenticate_user! # Ensure the user is authenticated for all actions by default

#   private

#   # Set session options to allow session storage in an API-only app
#   def set_session_options
#     request.session_options[:skip] = false
#   end

#   # Ensure requests are processed as JSON if not explicitly set
#   def ensure_json_request
#     request.format = :json unless params[:format]
#   end
# end


# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::Helpers
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection

  # protect_from_forgery with: :null_session
  protect_from_forgery with: :null_session, if: -> { request.format.json? }


  before_action :ensure_json_request
  before_action :authenticate_user! 

  private

  def authenticate_user!
    super
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { error: 'Invalid or expired token. Please sign in again.' }, status: :unauthorized
  end

  # Ensure requests are processed as JSON
  def ensure_json_request
    request.format = :json if request.headers['Content-Type'].nil? || request.headers['Content-Type'].include?('application/json')
  end
end

