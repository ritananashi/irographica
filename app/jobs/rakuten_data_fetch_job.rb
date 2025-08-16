class RakutenDataFetchJob < ApplicationJob
  queue_as :default

  def perform(product_id)
    product = Product.find(product_id)

    key = "インク #{product.name}"
    results_list = RakutenWebService::Ichiba::Product.search(keyword: key, genreId: '215783')
    unless results_list.any?
      sleep(1) # 制限回避用
      results_list = RakutenWebService::Ichiba::Item.search(keyword: key, genreId: '215783')
    end

    sleep(1) # 制限回避用

    if results_list.any?
      result = results_list.first
      product.update!(
        productUrl: result['itemUrl'] || result['productUrlPC'],
        imageUrl: result['mediumImageUrl'] || result['mediumImageUrls'][0]
      )
    end
  end
end
