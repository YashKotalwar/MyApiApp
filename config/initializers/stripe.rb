require 'stripe'

Stripe.api_key = Rails.application.credentials.dig(:stripe, :sk)

# Optionally set other Stripe configurations if needed
Stripe.max_network_retries = 2
