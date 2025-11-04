module RedminePlusAutomation
  module Patches
    module Models
      module IssuePatch
        def self.included(base)
          base.send(:include, InstanceMethods)

          base.class_eval do
            attr_accessor :skip_automation_triggers

            after_create_commit :automation_trigger_created, if: -> { !skip_automation_triggers }
            after_update_commit :automation_trigger_updated, if: -> { !skip_automation_triggers }
            after_destroy_commit :automation_trigger_deleted, if: -> { !skip_automation_triggers }
          end
        end

        module InstanceMethods

          private

          def automation_trigger_created
            ::AutomationNodes::Triggers::IssueCreated.trigger!(self)
          end

          def automation_trigger_updated
            ::AutomationNodes::Triggers::IssueUpdated.trigger!(self)
            ::AutomationNodes::Triggers::ValueChanged.trigger!(self)
          end

          def automation_trigger_deleted
            ::AutomationNodes::Triggers::IssueDeleted.trigger!(self)
          end
        end
      end
    end
  end
end

unless Issue.included_modules.include?(RedminePlusAutomation::Patches::Models::IssuePatch)
  Issue.send(:include, RedminePlusAutomation::Patches::Models::IssuePatch)
end
