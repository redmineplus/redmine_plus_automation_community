class AutomationLogQuery < Query
  self.queried_class = AutomationLog

  self.available_columns = [
    QueryColumn.new(:created_at, sortable: "#{queried_class.table_name}.created_at", caption: l(:field_created_on)),
    QueryColumn.new(:automation_rule),
    QueryColumn.new(:automation_node),
    QueryColumn.new(:message),
  ]

  def initialize_available_filters
  end

  def default_columns_names
    @default_columns_names ||= [:created_at, :automation_rule, :automation_node, :message]
  end
end
