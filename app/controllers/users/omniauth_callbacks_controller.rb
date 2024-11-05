class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token
  before_action :cors_preflight_check
  after_action :cors_set_access_control_headers

  def cors_preflight_check
    return unless request.method == 'OPTIONS'
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'
    headers['Access-Control-Max-Age'] = '1728000'
    render text: '', content_type: 'text/plain'
  end

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'
    headers['Access-Control-Max-Age'] = '1728000'
  end

  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      token = @user.generate_jwt
      render json: {
        status: :success,
        message: 'Successfully authenticated with Google',
        token: token,
        user: {
          email: @user.email
        }
      }, status: :ok
    else
      render json: {
        status: :error,
        message: 'Authentication failed',
        errors: @user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def failure
    render json: {
      status: :error,
      message: request.env['omniauth.error']&.message || 'Authentication failed'
    }, status: :unauthorized
  end
end
