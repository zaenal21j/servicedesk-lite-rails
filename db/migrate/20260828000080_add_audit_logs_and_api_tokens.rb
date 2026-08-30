class AddAuditLogsAndApiTokens < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :api_token, :string
    add_index :users, :api_token, unique: true

    create_table :audit_logs do |t|
      t.references :workspace, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :action, null: false
      t.string :record_type, null: false
      t.integer :record_id, null: false
      t.text :metadata, null: false, default: "{}"
      t.timestamps
    end
    add_index :audit_logs, %i[record_type record_id]
  end
end
