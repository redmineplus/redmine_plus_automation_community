module AutomationLogsHelper
  def automation_log_column_value(column, item)
    case column.name
    when :automation_rule
      if item.automation_rule&.editable?
        link_to item.automation_rule.name, automation_rule_path(item.automation_rule, project_id: @project&.identifier)
      else
        content_tag(:span, "#{item.automation_rule&.name || item.automation_rule_id}")
      end
    when :automation_node
      item.automation_node&.name
    else
      column_content(column, item)
    end
  end
end
