class InkRecipe < ApplicationRecord
  belongs_to :review

  validates :name, length: { maximum: 50 }
  validates :amount, numericality: { allow_nil: true, in: 0..30 }
end
