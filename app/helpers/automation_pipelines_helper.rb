module AutomationPipelinesHelper
  def automation_pipeline_column_value(column, item)
    case column.name
    when :id
      link_to item.id, automation_logs_path(pipeline_id: item, project_id: @project&.identifier)
    when :automation_rule
      if item.automation_rule&.editable?
        link_to item.automation_rule.name, automation_rule_path(item.automation_rule, project_id: @project&.identifier)
      else
        content_tag(:span, "#{item.automation_rule&.name || item.automation_rule_id}")
      end
    when :automation_branch
      if item.automation_branch && item.automation_rule&.editable?
        link_to item.automation_branch.name, automation_rule_path(item.automation_rule, project_id: @project&.identifier)
      elsif item.automation_branch_id
        content_tag(:span, "#{item.automation_branch&.name || item.automation_branch_id}")
      end
    else
      column_content(column, item)
    end
  end
end
