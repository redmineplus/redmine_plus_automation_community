module AutomationNodes
  module Actions
    class DeleteIssueService < ::AutomationNodes::Actions::EntityService
      def call
        action_entity.destroy! || failure(message: node_message(:failure_invalid))

        success(data: { destroyed: true }, message: node_message(:success))
      end

      private

      def action_base_entity
        entity
      end
    end
  end
end
