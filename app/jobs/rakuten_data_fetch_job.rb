class RakutenDataFetchJob < ApplicationJob
  queue_as :default

  def perform(product_id)
    product = Product.find(product_id)

    key = "インク #{product.name}"
    results_list = RakutenSearchService.call(key)

    if results_list.any?
      result = results_list.first
      product.update!(
        productUrl: result["itemUrl"] || result["productUrlPC"],
        imageUrl: result["mediumImageUrl"] || result["mediumImageUrls"][0]
      )
    end
  end
end
