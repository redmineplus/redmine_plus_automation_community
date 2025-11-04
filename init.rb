# This file is a part of Redmine Automation (redmine_plus_automation) plugin,
# Redmine automation plugin for redmine
#
# Copyright (C) 2025 INTEGRITY SOFTWARE LIMITED
# https://www.redmineplus.com/
# support@redmineplus.com
#
# redmine_plus_automation is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# redmine_plus_automation is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with redmine_plus_automation. If not, see <http://www.gnu.org/licenses/>.

Redmine::Plugin.register :redmine_plus_automation_community do
  name 'Redmine Plus Automation plugin'
  author 'Redmine plus'
  description 'This is an automation plugin for Redmine'
  version '0.1.1'
  url 'https://redmineplus.com/redmine-automation'
  author_url 'https://redmineplus.com'

  requires_redmine version_or_higher: '5.0'

  menu :admin_menu, :automation_rules, { controller: 'automation_rules', action: 'index' },
       caption: :label_automation_rules,
       html: { class: 'icon' }

  menu :project_menu, :automation_rules, { controller: 'automation_rules', action: 'index' },
       caption: :label_automation_rules,
       after: :gantt,
       param: :project_id

  project_module :automation_rules do
    permission :view_automation_rules, {
      automation_rules: [:show, :index, :context_menu],
      automation_nodes: [:index],
      automation_pipelines: [:index],
      automation_logs: [:index],
    }, read: true
    permission :manage_automation_rules, {
      automation_rules: [:new, :create, :edit, :update, :destroy, :update_nodes],
      automation_triggers: [
        :available_monitored_fields, :available_projects, :available_statuses, :available_trackers,
        :available_filters, :filter_conditions, :available_values, :available_users, :user_fields,
        :available_user_roles, :available_user_groups, :available_tokens, :available_values_with_tokens,
        :available_time_entry_activities, :available_users_with_fields
      ]
    }
  end

end

Dir[File.join(File.dirname(__FILE__), '/lib/redmine_plus_automation/**/*.rb')].each { |file| require_dependency file }
Dir[File.join(File.dirname(__FILE__), '/app/services/**/*.rb')].each { |file| require_dependency file }
