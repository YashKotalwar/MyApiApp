# frozen_string_literal: true
Devise.setup do |config|
  # config.secret_key = '2dcff7ea5ea826aafe1a4dbaf2cb20ee9d0d17b11695c541c6fc33a13476312b070179d66eee2e2686a43d782118d37ac4affd8bd1555ab1544efbdc6bd94fa9'

  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  require 'devise/orm/active_record'

  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 12
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other

  config.warden do |manager|
    manager.failure_app = CustomFailureApp
  end

  config.navigational_formats = [:json]
  config.skip_session_storage = [:http_auth, :params_auth]

  config.jwt do |jwt|
    jwt.secret = Rails.application.credentials.secret_key_base
    jwt.dispatch_requests = [['POST', %r{^/login$}],
    ['GET', %r{^/users/auth/google_oauth2/callback$}]]
    jwt.revocation_requests = [['DELETE', %r{^/logout$}]]
    jwt.expiration_time = 1.day.to_i
  end
  
end
