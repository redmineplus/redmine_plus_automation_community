class AutomationRunScheduledTriggersJob < ApplicationJob
  def perform
    User.current.as_automation_admin do
      AutomationNodes::Conditions::ScheduledTriggersService.new.perform
    end
  end
end