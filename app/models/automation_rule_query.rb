class AutomationRuleQuery < Query

  self.queried_class = AutomationRule

  self.available_columns = [
    QueryColumn.new(:name, sortable: "#{AutomationRule.table_name}.name", caption: l(:field_name)),
    QueryColumn.new(:enabled, sortable: "#{AutomationRule.table_name}.enabled", caption: l(:field_enabled)),
    QueryColumn.new(:is_for_all, :sortable => "#{AutomationRule.table_name}.is_for_all"),
    QueryColumn.new(:author, :sortable => lambda {User.fields_for_order_statement}),
    QueryColumn.new(:description, sortable: "#{AutomationRule.table_name}.description", caption: l(:field_description)),
    QueryColumn.new(:created_at, sortable: "#{AutomationRule.table_name}.created_at", caption: l(:field_created_on)),
    QueryColumn.new(:updated_at, sortable: "#{AutomationRule.table_name}.updated_at", caption: l(:field_updated_on))
  ]

  def initialize_available_filters
    add_available_filter "name", type: :string, label: :field_name
    add_available_filter "enabled", type: :list, values: [[l(:general_text_yes), '1'], [l(:general_text_no), '0']], label: :field_enabled
    add_available_filter "is_for_all", type: :list, values: [[l(:general_text_yes), '1'], [l(:general_text_no), '0']], label: :field_is_for_all
    add_available_filter "author_id", type: :list, values: User.all.map { |s| [s.name, s.id.to_s] }, label: :field_author
    add_available_filter "created_at", type: :date_past, label: :field_created_on
    add_available_filter "updated_at", type: :date_past, label: :field_updated_on
  end

  def available_columns
    return @available_columns if @available_columns

    @available_columns = self.class.available_columns.dup
  end

  def default_columns_names
    @default_columns_names ||= [:name, :description, :enabled, :is_for_all, :author, :created_at]
  end

  def project_statement
    nil
  end

  def base_scope
    base_scope = AutomationRule.visible.where(statement)
    base_scope = base_scope.for_project(project) if project
    base_scope
  end

  def results_scope(options = {})
    order_option = [group_by_sort_order, (options[:order] || sort_clause)].flatten.reject(&:blank?)
    order_option << "#{AutomationRule.table_name}.id ASC"

    scope = base_scope.order(order_option)
    scope = scope.like(options[:like]) if options[:like].present?
    scope
  end

end
