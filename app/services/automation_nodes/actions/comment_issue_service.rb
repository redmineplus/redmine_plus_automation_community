module AutomationNodes
  module Actions
    class CommentIssueService < ::AutomationNodes::Actions::EntityService
      def call
        action_entity.save || failure(message: node_message(:failure_invalid))

        success(data: { created: action_entity }, message: node_message(:success, comment: "#{issue_comment}"))
      end

      private

      def action_base_entity
        entity.init_journal(automation_user, issue_comment)
      end

      def issue_comment
        @issue_comment ||= replace_tokens(node.comment)
      end
    end
  end
end
