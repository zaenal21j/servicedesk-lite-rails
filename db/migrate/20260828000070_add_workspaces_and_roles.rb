class AddWorkspacesAndRoles < ActiveRecord::Migration[8.1]
  def change
    create_table :workspaces do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.timestamps
    end
    add_index :workspaces, :slug, unique: true

    add_reference :users, :workspace, foreign_key: true
    add_column :users, :role, :string, null: false, default: "viewer"
    add_reference :customers, :workspace, foreign_key: true

    reversible do |direction|
      direction.up do
        execute <<~SQL
          INSERT INTO workspaces (name, slug, created_at, updated_at)
          VALUES ('Default Workspace', 'default-workspace', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
        SQL
        execute "UPDATE users SET workspace_id = (SELECT id FROM workspaces LIMIT 1)"
        execute "UPDATE customers SET workspace_id = (SELECT id FROM workspaces LIMIT 1)"
      end
    end

    change_column_null :users, :workspace_id, false
    change_column_null :customers, :workspace_id, false
  end
end
