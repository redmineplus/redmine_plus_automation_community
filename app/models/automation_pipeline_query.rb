class AutomationPipelineQuery < Query
  self.queried_class = AutomationPipeline

  self.available_columns = [
    QueryColumn.new(:created_at, sortable: "#{queried_class.table_name}.created_at", caption: l(:field_created_on)),
    QueryColumn.new(:id, caption: l(:label_id)),
    QueryColumn.new(:automation_rule),
    QueryColumn.new(:automation_branch),
    QueryColumn.new(:status),
    QueryColumn.new(:author)
  ]

  def initialize_available_filters
  end

  def default_columns_names
    @default_columns_names ||= [:created_at, :id, :automation_rule, :automation_branch, :status, :author]
  end

  def default_sort_criteria
    [%w[created_at desc]]
  end
end
