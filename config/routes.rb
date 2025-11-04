# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :automation_rules do
  collection do
    get :context_menu
  end
  member do
    put :update_nodes
  end
end

resources :automation_pipelines, only: [:index] do
  collection do
    get :context_menu
  end
end

resources :automation_logs, only: [:index]

get '/automation_rules/:automation_rule_id/automation_nodes', :to => 'automation_nodes#index'

get '/projects/:project_id/automation_rules', :to => 'automation_rules#index'

get "automation_triggers/available_monitored_fields", to: "automation_triggers#available_monitored_fields"
get "automation_triggers/available_projects", to: "automation_triggers#available_projects"
get "automation_triggers/available_statuses", to: "automation_triggers#available_statuses"
get "automation_triggers/available_trackers", to: "automation_triggers#available_trackers"
get "automation_triggers/available_filters", to: "automation_triggers#available_filters"
get "automation_triggers/filter_conditions", to: "automation_triggers#filter_conditions"
get "automation_triggers/available_values", to: "automation_triggers#available_values"
get "automation_triggers/available_users", to: "automation_triggers#available_users"
get "automation_triggers/user_fields", to: "automation_triggers#user_fields"
get "automation_triggers/available_user_groups", to: "automation_triggers#available_user_groups"
get "automation_triggers/available_user_roles", to: "automation_triggers#available_user_roles"
get "automation_triggers/available_tokens", to: "automation_triggers#available_tokens"
get "automation_triggers/available_values_with_tokens", to: "automation_triggers#available_values_with_tokens"
get "automation_triggers/available_time_entry_activities", to: "automation_triggers#available_time_entry_activities"
get "automation_triggers/available_users_with_fields", to: "automation_triggers#available_users_with_fields"

namespace :automation_nodes do
  namespace :triggers do
    resources :manual_triggers, only: [] do
      member do
        post :perform
      end

      collection do
        get :visible_manual_triggers
      end
    end
  end
end