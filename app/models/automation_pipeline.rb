class AutomationPipeline < ActiveRecord::Base
  belongs_to :automation_rule
  belongs_to :automation_branch, class_name: "AutomationNodes::Branch", optional: true
  belongs_to :entity, polymorphic: true
  belongs_to :author, class_name: "User"
  has_many :automation_logs, dependent: :delete_all

  attr_accessor :prev_result
  delegate :automation_nodes, to: :automation_rule

  enum status: { scheduled: 0, in_progress: 1, success: 2, success_no_actions: 3, failed: 10, system: 20 }

  validates :automation_rule, presence: true
  validates :status, inclusion: { in: statuses.keys }
  # @todo generate uuid

  def run!
    pipeline_nodes.each do |node|
      self.prev_result = node.run!(self)

      return false unless prev_result.success?
    end
  end
  # @todo if rule/branch was changed/deleted meantime?
  def pipeline_nodes
    @pipeline_nodes ||= automation_branch ? automation_nodes.for_branch(automation_branch.uuid) : automation_nodes.for_pipeline
  end

  def action_nodes
    @action_nodes ||= pipeline_nodes.where("type LIKE 'AutomationNodes::Actions::%'")
  end

  def action_logs
    @action_logs ||= automation_logs.where(automation_node: action_nodes)
  end

  def complete!
    action_logs.exists? ? success! : success_no_actions!
  end

  def entity_name
    "#{entity.class} - ##{entity.id}"
  end

  def log(node, message)
    automation_logs.create(automation_node: node, message: message)
  end
end
