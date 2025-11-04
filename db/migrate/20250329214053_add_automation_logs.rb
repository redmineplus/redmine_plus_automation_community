class AddAutomationLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :automation_logs do |t|
      t.references :automation_pipeline, null: false, index: true
      t.references :automation_node, null: false, index: true
      t.text :message, null: true

      t.datetime :created_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
  end
end
