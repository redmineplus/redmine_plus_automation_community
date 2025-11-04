module AutomationNodes
  module Actions
    class DeleteAttachmentService < ::AutomationNodes::Actions::EntityService
      def call
        attachments = entity_attachments
        return success(message: node_message(:skipped)) if attachments.empty?

        attachments.each do |attachment|
          init_entity_journal
          # Make sure association callbacks are called
          entity.attachments.delete(attachment) || failure(message: node_message(:failure_invalid, errors: attachment.errors.full_messages.to_sentence))
        end

        success(message: node_message(:success))
      end

      private

      def node_regex
        @node_regex ||= Regexp.new(replace_tokens(node.regex))
      end

      def entity_attachments
        case node.delete_type
        when "all"
          entity.attachments
        when "matching"
          entity.attachments.select { |attachment| attachment.filename =~ node_regex }
        when "not_matching"
          entity.attachments.reject { |attachment| attachment.filename =~ node_regex }
        else
          failure(status: :system, message: node_message(:failure_delete_type, value: node.delete_type))
        end
      end
    end
  end
end
