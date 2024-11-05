require 'stripe'

class ProductsController < ApplicationController
  def index
    products = Stripe::Product.list(limit: 10)
    render json: { products: products.data }
  end

  def create
    byebug
    product = Stripe::Product.create({
      name: params[:name],
      description: params[:description]
    })

    render json: { message: 'Product created successfully', product: product }
  rescue Stripe::StripeError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def destroy
    product_id = params[:id]
    deleted_product = Stripe::Product.delete(product_id)

    render json: { message: 'Product deleted successfully', deleted_product: deleted_product }
  rescue Stripe::InvalidRequestError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
