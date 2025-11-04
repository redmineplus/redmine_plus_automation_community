module RedminePlusAutomation
  module AutomationTriggers
    class ManualTriggers

      def initialize(user, issue)
        @user = user
        @issue = issue
      end

      def visible_manual_rules
        project = issue.project
        automation_rules = AutomationRule.left_outer_joins(:projects)
          .where("projects.id = ? OR automation_rules.is_for_all = ?", project.id, true)
          .joins(:automation_nodes)
          .preload(:automation_nodes)
          .where(automation_nodes: { type: "AutomationNodes::Triggers::Manual" }, automation_rules: { enabled: true })

        automation_rules.select do |rule|
          rule.automation_nodes.any? do |node|
            node.is_a?(::AutomationNodes::Triggers::Manual) && node.can_run?(user, issue)
          end
        end
      end

      private

      attr_reader :user, :issue

    end
  end
end
