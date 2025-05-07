class CreateInkRecipes < ActiveRecord::Migration[7.2]
  def change
    create_table :ink_recipes do |t|
      t.references :review, null: false, foreign_key: true
      t.string :name
      t.integer :amount

      t.timestamps
    end
  end
end
