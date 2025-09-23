class DeleteNameUniqIndexFromProduct < ActiveRecord::Migration[7.2]
  def change
    remove_index :products, column: :name
  end
end
