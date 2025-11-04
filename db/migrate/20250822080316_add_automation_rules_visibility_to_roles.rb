class AddAutomationRulesVisibilityToRoles < ActiveRecord::Migration[6.1]
  def change
    add_column :roles, :automation_rules_visibility, :string, limit: 30, default: "all", null: false
  end
end
