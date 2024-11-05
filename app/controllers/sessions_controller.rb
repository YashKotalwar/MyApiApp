class SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :verify_signed_out_user, only: :destroy


  # Override the create action to handle invalid login attempts
  def create
    user = User.find_for_authentication(email: params[:user][:email])

    # Check if the password is valid for the found user
    if user&.valid_password?(params[:user][:password])
      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      render json: { message: 'Logged in successfully', token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def current_token
    request.env['warden-jwt_auth.token']
  end

  def respond_to_on_destroy
    current_user ? log_out_success : log_out_failure
  end

  def log_out_success
    render json: { message: 'Logged out successfully' }
  end

  def log_out_failure
    render json: { message: 'Log out failed' }, status: :unauthorized
  end
end

