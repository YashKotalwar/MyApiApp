# app/controllers/subscriptions_controller.rb
class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:cancel]

  # Cancel the subscription for the specified user
  def cancel
    # Retrieve the Stripe subscription ID from the user record
    subscription_id = @user.stripe_subscription_id

    # Cancel the subscription at the end of the billing period
    canceled_subscription = Stripe::Subscription.update(
      subscription_id,
      { cancel_at_period_end: true }
    )

    # Optionally, update the user's subscription status
    # @user.update(unsubscribed: true, subscription_expiration: Time.at(canceled_subscription.current_period_end))

    render json: { message: 'Subscription will cancel at the end of the billing period', subscription: canceled_subscription }
  rescue Stripe::InvalidRequestError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  # Find user by the given :user_id param
  def set_user
    @user = User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end
end
