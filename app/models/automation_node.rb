class AutomationNode < ActiveRecord::Base
  include Redmine::I18n
  belongs_to :automation_rule
  has_many :automation_logs

  scope :root, -> { where(parent_node_uuid: nil) }
  scope :non_trigger, -> { where("type NOT LIKE 'AutomationNodes::Trigger%'") }
  scope :non_scope_query, -> { where.not(type: "AutomationNodes::Conditions::QueryScope") }
  scope :sorted, -> { order(:position) }
  scope :for_pipeline, -> { root.non_trigger.non_scope_query.sorted }
  scope :for_branch, ->(uuid) { uuid.present? ? where(parent_node_uuid: uuid).non_trigger.sorted : none }

  def mapping_type
    self.class.name.demodulize.underscore.upcase
  end

  def i18n_key
    self.class.name.underscore.gsub('/', '.')
  end

  def node_l(key, options = {})
    options[:scope] ||= i18n_key
    options[:default] ||= key
    l(key, options)
  end

  def node_type
    case self.class.to_s
    when /^AutomationNodes::Actions::/
      "action"
    when /^AutomationNodes::Conditions::/
      "condition"
    when /^AutomationNodes::Branches::/
      "branch"
    when /^AutomationNodes::Triggers::/
      "trigger"
    else
      "unknown"
    end
  end

  def action?
    node_type == "action"
  end

  def condition?
    node_type == "condition"
  end

  def branch?
    node_type == "branch"
  end

  def trigger?
    node_type == "trigger"
  end

  def run!
    raise NotImplementedError
  end
end
