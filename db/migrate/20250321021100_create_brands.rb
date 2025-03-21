class CreateBrands < ActiveRecord::Migration[7.2]
  def change
    create_table :brands do |t|
      t.string :name, null: false
      t.string :official_url
      t.string :official_shopping_url

      t.timestamps
    end

    add_index :brands, :name, unique: true
  end
end
