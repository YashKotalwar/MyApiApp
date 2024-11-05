# Rails.application.config.to_prepare do
#   # Only override DeviseController if Devise is loaded
#   if defined?(DeviseController)
#     DeviseController.class_eval do
#       protected

#       # Override flash behavior to prevent errors in API mode
#       def set_flash_message(key, kind, options = {})
#         # Do nothing to disable flash
#       end

#       def set_flash_message!(key, kind, options = {})
#         # Do nothing to disable flash
#       end
#     end
#   end
# end

Rails.application.config.to_prepare do
  if defined?(DeviseController)
    DeviseController.class_eval do
      protected

      # Override flash behavior to prevent errors in API mode
      def set_flash_message(key, kind, options = {})
        # Do nothing to disable flash
      end

      def set_flash_message!(key, kind, options = {})
        # Do nothing to disable flash
      end
    end
  end

  # Override Devise's failure app to handle JSON responses without flash
  Devise::FailureApp.class_eval do
    def respond
      if request.format == :json
        json_error_response
      else
        super
      end
    end

    private

    def json_error_response
      self.status = 401
      self.content_type = 'application/json'
      self.response_body = { error: i18n_message }.to_json
    end
  end
end
