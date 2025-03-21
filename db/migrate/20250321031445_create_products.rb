class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.references :brand, null: false, foreign_key: true

      t.timestamps
    end

    add_index :products, :name, unique: true
  end
end
