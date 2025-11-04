module AutomationNodes
  module Actions
    class EntityService < ::AutomationService

      private

      # @example @action_base_entity ||= Issue.find_by() || Issue.new || entity.dup || entity
      def action_base_entity
        raise NotImplementedError, "This method should be implemented in subclasses"
      end

      # @example @action_issue ||= prepare_issue(Issue.find_by() || Issue.new)
      def action_entity
        @action_entity ||= prepare_action_entity
      end

      def action_entity_errors
        @action_entity_errors = action_entity.errors.full_messages.to_sentence
      end

      def prepare_action_entity
        base_entity = action_base_entity
        skip_automation_triggers(base_entity)
        base_entity
      end

      def init_entity_journal(jouranlized = entity)
        journal = jouranlized.init_journal(automation_user)
        skip_automation_triggers(journal)
        journal
      end

      def skip_automation_triggers(entity)
        entity&.skip_automation_triggers = true
      end

      def node_message(key, options = {})
        options[:errors] ||= action_entity_errors if key == :failure_invalid
        super(key, options)
      end
    end
  end
end
