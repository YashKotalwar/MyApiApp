class RegistrationsController < Devise::RegistrationsController
	respond_to :json

	private

	def respond_with(resource, _opts = {})
		register_success && return if resource.persisted?

		register_failed
	end

	def register_success
		render json: { message: 'Signed up successfully.' }
	end

	def register_failed
		render json: { message: 'Sign up failed.' }, status: :unprocessable_entity
	end
end
