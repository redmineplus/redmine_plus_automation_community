module AutomationNodes
  module Actions
    class LogWorkService < ::AutomationNodes::Actions::EntityService
      def call
        action_entity.save || failure(message: node_message(:failure_invalid))

        success(message: node_message(:success, time: action_entity.hours))
      end

      private

      def action_base_entity
        entity = TimeEntry.new
        entity.safe_attributes = entity_attributes
        entity
      end

      def entity_attributes
        {
          project_id: entity.project_id,
          issue_id: entity.id,
          user_id: resolve_token(node.user_id),
          spent_on: resolve_token(node.date),
          activity_id: node.activity,
          hours: replace_tokens(node.spent_time),
          comments: replace_tokens(node.comment)
        }
      end
    end
  end
end
