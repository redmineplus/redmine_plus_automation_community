module RedminePlusAutomation
  module Patches
    module Models
      module JournalPatch
        def self.included(base)
          base.send(:include, InstanceMethods)

          base.class_eval do
            attr_accessor :skip_automation_triggers

            after_create_commit :automation_trigger_created, if: -> { !skip_automation_triggers && notes.present? }
            after_update_commit :automation_trigger_updated, if: -> { !skip_automation_triggers && notes.present? }
          end
        end

        module InstanceMethods

          private

          def automation_trigger_created
            ::AutomationNodes::Triggers::IssueCommentCreated.trigger!(journalized) if journalized_type == "Issue"
          end

          def automation_trigger_updated
            ::AutomationNodes::Triggers::IssueCommentUpdated.trigger!(journalized) if journalized_type == "Issue"
          end
        end
      end
    end
  end
end

unless Journal.included_modules.include?(RedminePlusAutomation::Patches::Models::JournalPatch)
  Journal.send(:include, RedminePlusAutomation::Patches::Models::JournalPatch)
end
