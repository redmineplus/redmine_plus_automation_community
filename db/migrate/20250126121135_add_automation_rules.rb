class AddAutomationRules < ActiveRecord::Migration[6.1]
  def change
    create_table :automation_rules do |t|
      t.string :name, null: true
      t.text :description, null: true
      t.boolean :enabled, null: false, default: false
      t.boolean :is_for_all, null: false, default: false
      t.integer :author_id, null: false, index: true

      t.timestamps null: false
    end

    create_table :automation_rules_projects, id: false do |t|
      t.belongs_to :automation_rule
      t.belongs_to :project
    end
  end
end
