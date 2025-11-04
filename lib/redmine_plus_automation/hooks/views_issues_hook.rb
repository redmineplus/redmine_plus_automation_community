module RedminePlusAutomation
  module Hooks
    class ViewsIssuesHook < Redmine::Hook::ViewListener

    render_on :view_issues_show_details_bottom, partial: "issues/redmine_automations/issues_automation_dropdown"

    # If you want to include the React component globally
    # def view_layouts_base_html_head(context = {})
    #   javascript_include_tag('redmine_plus_automation_bundle', plugin: :redmine_plus_automation)
    # end
    end
  end
end