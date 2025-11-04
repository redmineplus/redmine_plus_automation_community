module AutomationNodes
  module Actions
    class EditCommentService < ::AutomationNodes::Actions::EntityService
      def call
        action_entity.save || failure(message: node_message(:failure_invalid))

        success(data: { created: action_entity }, message: node_message(:success, comment: "#{comment_text}"))
      end

      private

      def action_base_entity
        journal = resolve_token(node.target_comment)
        failure(message: node_message(:failure_no_comments)) unless journal.is_a?(Journal)
        journal
      end

      def prepare_action_entity
        journal = super
        journal.notes = comment_text
        journal.updated_by = automation_user
        journal
      end

      def comment_text
        @comment_text ||= replace_tokens(node.comment_text)
      end
    end
  end
end
