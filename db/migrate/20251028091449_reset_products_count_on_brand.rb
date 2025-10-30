class ResetProductsCountOnBrand < ActiveRecord::Migration[7.2]
  def up
    Brand.find_each { |i| Brand.reset_counters(i.id, :products) }
  end
end
