module RedminePlusAutomation
  module Hooks
    class ViewsLayoutsHook < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(context={})
        return stylesheet_link_tag(:redmine_automation, :plugin => 'redmine_plus_automation')
      end
    end
  end
end
