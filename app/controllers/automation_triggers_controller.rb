class AutomationTriggersController < ApplicationController
  before_action :authorize_global

  def available_monitored_fields
    render json: RedminePlusAutomation::AutomationTriggers::MonitoredFields.all
  end

  def available_projects
    @projects = Project.where(status: Project::STATUS_ACTIVE)
                       .where("name LIKE ?", "%#{params[:term]}%")
                       .order(:name)
                       .limit(10)

    render json: @projects.map { |project| { id: project.id, name: project.name } }
  end

  def available_statuses
    render json: IssueStatus.all.map { |status| { id: status.id, name: status.name } }
  end

  def available_trackers
    render json: Tracker.all.map { |tracker| { id: tracker.id, name: tracker.name } }
  end

  def available_filters
    render json: RedminePlusAutomation::Conditions::AvailableFilters.all
  end

  def filter_conditions
    render json: RedminePlusAutomation::Conditions::FilterConditions.new(params[:filter]).conditions
  end

  def available_values
    filter = IssueQuery.new.available_filters[params[:filter]]
    values = filter&.values || []

    render json: values.map { |value| { value: value[1], label: value[0] } }
  end

  def available_users
    users = User.active.to_a.filter { |user| user.name =~ /#{params[:term]}/i }
    render json: users.map { |user| { value: user.id, label: user.name } }
  end

  def user_fields
    render json: IssueCustomField
      .where(field_format: "user")
      .map { |field| { value: "issue.cf_#{field.id}", label: field.name } }
      .push({ value: "issue.author.id", label: l(:field_author) })
  end

  def available_user_roles
    render json: Role
                   .where("name LIKE ?", "%#{params[:term]}%")
                   .map { |role| { value: role.id, label: role.name } }
  end

  def available_user_groups
    render json: Group.all.to_a.filter { |user| user.name =~ /#{params[:term]}/i }
                   .map { |group| { value: group.id, label: group.name } }
  end

  def available_tokens
    render json: RedminePlusAutomation::AutomationTokens.all
  end

  def available_values_with_tokens
    filter = IssueQuery.new.available_filters[params[:filter]]
    values = filter&.values || []
    values.each do |pair|
      pair[1] = "initiator.id" if pair[1] == "me"
    end
    tokens = RedminePlusAutomation::AutomationTokens.tokens_by_column_name[params[:filter]] || []

    render json: tokens.concat(values.map { |value| { value: value[1], label: value[0] } })
  end

  def available_time_entry_activities
    render json: TimeEntryActivity.active.map { |activity| { value: activity.id, label: activity.name } }
  end

  def available_users_with_fields
    users = User.active.map { |user| { value: "user_#{user.id}", label: user.name, group: "Users" } }
    user_groups = Group.all.map { |group| { value: "group_#{group.id}", label: group.name, group: "Groups" } }
    fields = IssueCustomField
      .where(field_format: %w[user string])
      .map { |field| { value: "issue.cf_#{field.id}", label: field.name, group: "Triggered issue fields" } }
      .push({ value: "issue.author.mail", label: l(:field_author), group: "Triggered issue fields" })
      .push({ value: "issue.assigned_to.mail", label: l(:field_assigned_to), group: "Triggered issue fields" })

    render json: users.concat(user_groups).concat(fields)
  end
end