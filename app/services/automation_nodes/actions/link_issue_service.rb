module AutomationNodes
  module Actions
    class LinkIssueService < ::AutomationNodes::Actions::EntityService
      def call
        action_entity.save || failure(message: node_message(:failure_invalid))

        success(message: node_message(:success, from: "##{action_entity.issue_from_id}", to: "##{action_entity.issue_to_id}"))
      end

      private

      def action_base_entity
        relation = IssueRelation.new
        relation.issue_from = entity
        relation.safe_attributes = entity_attributes

        relation.init_journals(automation_user)
        skip_automation_triggers(relation.issue_from&.current_journal)
        skip_automation_triggers(relation.issue_to&.current_journal)

        relation
      end

      def entity_attributes
        {
          issue_to_id: issue_to_id,
          relation_type: node.link_type,
        }
      end

      def issue_to_id
        case node.issue
        when "issue.most_recent_created_issue"
          prev_result.data[:created]&.id || failure(message: node_message(:failure_created))
        when "issue.trigger"
          entity.id
        else
          failure(status: :system, message: node_message(:failure_issue))
        end
      end

    end
  end
end
