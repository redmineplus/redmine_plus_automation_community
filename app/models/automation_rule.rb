class AutomationRule < ActiveRecord::Base
  include Redmine::SafeAttributes

  belongs_to :author, class_name: "User"
  has_and_belongs_to_many :projects
  has_many :automation_nodes, dependent: :delete_all
  has_many :automation_pipelines, dependent: :delete_all

  safe_attributes "name", "author_id", "description", "enabled", "project_ids", "is_for_all"

  scope :enabled, -> { where(enabled: true) }
  scope :for_project, ->(project) do
    project ? left_outer_joins(:projects).where("projects.id = ? OR is_for_all = ?", project.id, true) : where(is_for_all: true)
  end
  scope :like, lambda { |arg|
    if arg.present?
      pattern = "%#{arg.to_s.strip}%"
      where("LOWER(automation_rules.name) LIKE LOWER(:p)", p: pattern)
    end
  }
  scope :visible, lambda { |*args|
    user = args.shift || User.current
    user.admin? ? all : left_outer_joins(:projects).where(AutomationRule.visible_condition(user, *args))
  }

  # Returns a SQL conditions string used to find all automation rules visible by the specified user
  def self.visible_condition(user, options = {})
    Project.allowed_to_condition(user, :view_automation_rules, options) do |role, user|
      if role.automation_rules_visibility == "all"
        nil
      elsif role.automation_rules_visibility == "own" && user.id && user.logged?
        "#{table_name}.author_id = #{user.id}"
      else
        "1=0"
      end
    end
  end

  # Returns true if user or current user is allowed to view the automation rule
  def visible?(user = nil, project = nil)
    user ||= User.current
    return true if user.admin?
    return false if is_for_all? || projects.empty?

    automation_projects = project ? [project] : projects
    automation_projects.any? do |p|
      user.allowed_to?(:view_automation_rules, p) do |role, user|
        if role.automation_rules_visibility == "all"
          true
        elsif role.automation_rules_visibility == "own"
          author == user
        else
          false
        end
      end
    end
  end

  def editable?(user = nil)
    user ||= User.current
    return true if user.admin?
    return false if is_for_all? || projects.empty?

    projects.all? do |p|
      user.allowed_to?(:manage_automation_rules, p) do |role, user|
        if role.automation_rules_visibility == "all"
          true
        elsif role.automation_rules_visibility == "own"
          author == user
        else
          false
        end
      end
    end
  end

  def deletable?(user = nil)
    editable?(user)
  end

  # @todo validations for nodes

  def css_classes
    ""
  end
end
