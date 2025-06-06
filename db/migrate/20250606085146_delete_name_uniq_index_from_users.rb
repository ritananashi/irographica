class DeleteNameUniqIndexFromUsers < ActiveRecord::Migration[7.2]
  def change
    remove_index :users, column: :name
  end
end
