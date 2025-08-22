product_all = Product.where.not("name LIKE ?", "%オリジナル%")

product_all.each do |product|
  search_result = RakutenWebService::Ichiba::Product.search(keyword: "インク　#{product.name}", genreId: '215783')
  unless search_result.any?
    sleep(1)
    search_result = RakutenWebService::Ichiba::Item.search(keyword: "インク　#{product.name}", genreId: '215783')
  end
  sleep(1)
  if search_result.any?
    result = search_result.first
    product.update!(
      productUrl: result['itemUrl'] || result['productUrlPC'],
      imageUrl: result['mediumImageUrl'] || result['mediumImageUrls'][0]
    )
  end
end
