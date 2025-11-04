module AutomationNodes
  module Actions
    class CreateIssueService < ::AutomationNodes::Actions::IssueService
      def call
        action_entity.save || failure(message: node_message(:failure_invalid))

        success(data: { created: action_entity }, message: node_message(:success, created: "##{action_entity.id}"))
      end

      private

      def action_base_entity
        Issue.new
      end

      def prepare_action_entity
        issue = super
        issue.author_id = issue_author_id
        issue
      end
    end
  end
end
