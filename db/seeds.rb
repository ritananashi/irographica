# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "csv"

# Brand登録用
# CSV.foreach('db/csv/brands.csv', headers: true) do |row|
#   Brand.find_or_create_by!(name: row['name']) do |brand|
#     brand.name = row['name']
#     brand.official_url = row['official_url']
#     brand.official_shopping_url = row['official_shopping_url']
#   end
# end

# Product登録用
CSV.foreach('db/csv/products.csv', headers: true) do |row|
  brand = Brand.find_by(name: row['brand_name'])
  category = Category.find_by(color: row['category'])
  Product.find_or_create_by!(name: row['name']) do |product|
    product.name = row['name']
    product.brand_id = brand.id
    product.category_id = category.id
  end
end
