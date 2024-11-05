# app/controllers/api_controller.rb
class ApiController < ActionController::API
  before_action :ensure_json_request

  private

  def ensure_json_request
    request.format = :json if request.format.html?
  end
end
