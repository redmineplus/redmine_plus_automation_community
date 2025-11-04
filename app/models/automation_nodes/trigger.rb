module AutomationNodes
  class Trigger < AutomationNode
    attr_accessor :entity

    scope :enabled_for_project, ->(project) { where(automation_rule: AutomationRule.enabled.for_project(project)) }

    class << self
      def trigger_scope(entity, options = {})
        options[:project] ||= entity.project if entity.respond_to?(:project)
        enabled_for_project(options[:project])
      end

      def trigger!(entity, options = {})
        trigger_scope(entity, options).each do |trigger|
          trigger.entity = entity
          next unless trigger.triggered?

          trigger.run!
        end
      end
    end

    def triggered?
      true
    end

    def run!
      AutomationPipelineJob.schedule(self, entity)
    end
  end
end
