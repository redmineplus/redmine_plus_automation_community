module AutomationRulesHelper
  def automation_rule_column_value(column, item)
    if column.name == :name && item.editable?
      link_to item.name, automation_rule_path(item, project_id: @project&.identifier)
    else
      column_content(column, item)
    end
  end
end
