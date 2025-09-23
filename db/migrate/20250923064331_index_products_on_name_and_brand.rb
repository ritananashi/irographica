class IndexProductsOnNameAndBrand < ActiveRecord::Migration[7.2]
  def change
    add_index :products, [:name, :brand_id], unique: true
  end
end
