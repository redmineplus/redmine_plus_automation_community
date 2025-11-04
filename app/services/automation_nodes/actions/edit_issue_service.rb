module AutomationNodes
  module Actions
    class EditIssueService < ::AutomationNodes::Actions::IssueService
      def call
        action_entity.save || failure(message: node_message(:failure_invalid))

        success(message: node_message(:success))
      end

      private

      def action_base_entity
        init_entity_journal
        entity
      end
    end
  end
end
