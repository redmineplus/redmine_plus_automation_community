class AddAutomationNode < ActiveRecord::Migration[6.1]
  def change
    create_table :automation_nodes do |t|
      t.string :uuid, null: false
      t.string :name
      t.string :description
      t.integer :position, null: false
      t.string :type, null: false
      t.string :parent_node_uuid, index: true
      t.references :automation_rule, null: false, foreign_key: true
      t.text :metadata

      t.timestamps null: false

      t.index :uuid, unique: true
    end
  end
end
