require 'stripe'
class PlansController < ApplicationController
  # before_action :authenticnate_admin! # Optional: Restrict this to admin users if needed
  # before_action :authenticate_user!

  def index
    @plan = Stripe::Plan.list(limit: 10)
    render json: { plan: @plan.data }
  end

  def create
    plan = Stripe::Plan.create({
      amount: params[:amount], # Amount in cents (e.g., $10/month is 1000)
      interval: params[:interval], # `month`, `year`, etc.
      # product: { name: params[:name] },
      currency: 'usd',
      nickname: params[:nickname],
      product: params[:product_id]
    })

    render json: { message: 'Plan created successfully', plan: plan }
  rescue Stripe::StripeError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def destroy
    plan_id = params[:id] # Retrieve the plan_id from the route parameter
    deleted_plan = Stripe::Plan.delete(plan_id) # Delete the plan in Stripe

    render json: { message: 'Plan deleted successfully', deleted_plan: deleted_plan }
  rescue Stripe::InvalidRequestError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
