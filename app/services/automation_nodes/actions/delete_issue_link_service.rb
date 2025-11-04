module AutomationNodes
  module Actions
    class DeleteIssueLinkService < ::AutomationNodes::Actions::EntityService
      def call
        return success(message: node_message(:skipped)) if entity_relations.empty?

        entity_relations.each do |relation|
          relation.init_journals(automation_user)
          skip_automation_triggers(relation.issue_from&.current_journal)
          skip_automation_triggers(relation.issue_to&.current_journal)
          skip_automation_triggers(relation)
          relation.destroy || failure(message: node_message(:failure_invalid, errors: relation.errors.full_messages.to_sentence))
        end

        success(message: node_message(:success))
      end

      private

      def entity_relations
        @entity_relations ||= entity.relations.select { |r| node.link_types.include?(r.relation_type_for(entity)) }
      end

      def node_message(key, options = {})
        options[:types] ||= node.link_types
        super(key, options)
      end
    end
  end
end
