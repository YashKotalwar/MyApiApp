# # config/initializers/omniauth.rb
# require 'omniauth/strategies/google_oauth2'

# OmniAuth.config.allowed_request_methods = [:post, :get]
# OmniAuth.config.silence_get_warning = true

# OmniAuth.config.middleware = Proc.new {}

# OmniAuth.config.before_request_phase do |env|
#   request = Rack::Request.new(env)
#   state = SecureRandom.hex(24)
#   request.session['omniauth.state'] = state
#   env['omniauth.strategy'].options[:state] = state
# end

# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :google_oauth2,
#     Rails.application.credentials.dig(:google_oauth, :client_id),
#     Rails.application.credentials.dig(:google_oauth, :client_secret),
#     {
#       provider_ignores_state: true, # Add this line
#       scope: 'email,profile',
#       prompt: 'select_account',
#       access_type: 'offline'
#     }
# end

require 'omniauth/strategies/google_oauth2'

# Configure OmniAuth for API mode
OmniAuth.config.allowed_request_methods = [:get, :post]
OmniAuth.config.silence_get_warning = true
OmniAuth.config.path_prefix = '/users/auth'

# Add CSRF protection
OmniAuth.config.request_validation_phase = proc { |env| }

Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :google_oauth2,
  #   Rails.application.credentials.dig(:google_oauth, :client_id),
  #   Rails.application.credentials.dig(:google_oauth, :client_secret),
  #   {
  #     provider_ignores_state: true,
  #     scope: 'email,profile',
  #     prompt: 'select_account',
  #     access_type: 'offline',
  #     skip_jwt: true,
  #     origin_param: 'return_to'
  #   }

  provider :google_oauth2,
            Rails.application.credentials.dig(:google_oauth, :client_id),
            Rails.application.credentials.dig(:google_oauth, :client_secret),
            {
              scope: 'userinfo.email,userinfo.profile',
              prompt: 'select_account',
              access_type: 'offline', # offline access for refresh tokens
              skip_jwt: true
            }
end