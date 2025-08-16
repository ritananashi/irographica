class AddRakutenColumToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :productUrl, :string
    add_column :products, :imageUrl, :string
  end
end
