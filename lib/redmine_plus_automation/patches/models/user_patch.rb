module RedminePlusAutomation
  module Patches
    module Models
      module UserPatch
        def self.included(base)
          base.send(:include, InstanceMethods)

          base.class_eval do
          end
        end

        module InstanceMethods
          def as_automation_admin
            automation_user = AutomationUser.first
            automation_user ||= AutomationUser.create!(login: 'automation', firstname: 'Automation', lastname: 'User', status: AutomationUser::STATUS_ANONYMOUS, admin: true)
            og_admin = User.current
            User.current = automation_user
            yield
          ensure
            User.current = og_admin
          end
        end
      end
    end
  end
end

unless User.included_modules.include?(RedminePlusAutomation::Patches::Models::UserPatch)
  User.send(:include, RedminePlusAutomation::Patches::Models::UserPatch)
end
