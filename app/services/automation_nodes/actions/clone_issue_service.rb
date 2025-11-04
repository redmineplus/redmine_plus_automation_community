module AutomationNodes
  module Actions
    class CloneIssueService < ::AutomationNodes::Actions::IssueService
      def call
        action_entity.save || failure(message: node_message(:failure_invalid))

        success(data: { created: action_entity }, message: node_message(:success, created: "##{action_entity.id}"))
      end

      private

      def action_base_entity
        entity.dup
      end
    end
  end
end
