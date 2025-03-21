class AddCategoryIdToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :category_id, :integer, null: false

    add_index :products, :category_id
  end
end
