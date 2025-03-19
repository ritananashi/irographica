class AddNameToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :account, :string, null: false

    add_index :users, :name, unique: true
    add_index :users, :account, unique: true
  end
end
