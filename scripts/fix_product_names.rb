shikiori_all = Product.where("name Like ?", "%四季織%")
shikiori_all.each do |shikiori|
  new_name = shikiori.name.gsub(/[SHIKIORI\s―]/, "")
  shikiori.update!(name: new_name)
end
