class CreateTickets < ActiveRecord::Migration[8.1]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :email
      t.string :company
      t.string :phone

      t.timestamps
    end

    create_table :tickets do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :subject
      t.text :description
      t.string :status
      t.string :priority

      t.timestamps
    end
  end
end
