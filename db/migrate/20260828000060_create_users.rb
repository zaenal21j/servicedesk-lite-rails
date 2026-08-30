class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    return if table_exists?(:users)
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
