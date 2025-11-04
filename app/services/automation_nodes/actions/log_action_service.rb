module AutomationNodes
  module Actions
    class LogActionService < ::AutomationService
      def call
        success(message: log_message)
      end

      private

      def log_message
        @log_message ||= replace_tokens(node.message)
      end
    end
  end
end
