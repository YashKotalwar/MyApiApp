class RecurringSubscriptionsController < ApplicationController
  before_action :authenticate_user! # Ensure user is logged in

  def create
    plan_id = params[:plan_id]

    # Create or retrieve Stripe customer
    customer = if current_user.stripe_customer_id
                 Stripe::Customer.retrieve(current_user.stripe_customer_id)
               else
                 Stripe::Customer.create(email: current_user.email, source: params[:stripeToken])
               end

    # Save customer ID to user
    current_user.update(stripe_customer_id: customer.id) unless current_user.stripe_customer_id

    # Create subscription in Stripe
    subscription = Stripe::Subscription.create(
      customer: customer.id,
      items: [{ plan: plan_id }]
    )

    # Save subscription details to user
    current_user.update(
      stripe_subscription_id: subscription.id,
      plan_id: plan_id
    )

    render json: { message: 'Subscription created successfully', subscription: subscription }
  rescue Stripe::StripeError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
