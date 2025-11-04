class AddAutomationPipeline < ActiveRecord::Migration[6.1]
  def change
    create_table :automation_pipelines do |t|
      t.references :automation_rule, null: false, foreign_key: true, index: true
      t.references :automation_branch, null: true, foreign_key: { to_table: :automation_nodes }, index: true
      t.references :entity, polymorphic: true, null: false, index: true
      t.integer :status, null: false, default: 0
      t.references :author, null: false

      t.timestamps
    end
  end
end
