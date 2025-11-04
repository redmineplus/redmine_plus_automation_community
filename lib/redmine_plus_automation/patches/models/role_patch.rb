module RedminePlusAutomation
  module Patches
    module Models
      module RolePatch
        def self.included(base)
          base.class_eval do
            ::Role.const_set :AUTOMATION_RULES_VISIBILITY_OPTIONS, [
              ["all", :label_automation_rules_visibility_all],
              ["own", :label_automation_rules_visibility_own]
            ].freeze

            validates_inclusion_of(
              :automation_rules_visibility,
              in: ::Role::AUTOMATION_RULES_VISIBILITY_OPTIONS.collect(&:first),
              if: lambda { |role| role.respond_to?(:automation_rules_visibility) && role.automation_rules_visibility_changed? })

            safe_attributes "automation_rules_visibility"
          end
        end
      end
    end
  end
end

unless Role.included_modules.include?(RedminePlusAutomation::Patches::Models::RolePatch)
  Role.send(:include, RedminePlusAutomation::Patches::Models::RolePatch)
end
