class AutomationLog < ActiveRecord::Base
  belongs_to :automation_pipeline
  belongs_to :automation_node

  delegate :automation_rule, :author, :entity, to: :automation_pipeline

  validates :automation_pipeline, presence: true
end
