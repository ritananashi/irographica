class RakutenSearchService
  attr_reader :keywords

  # 楽天API「文房具」ジャンルID
  RAKUTEN_GENRE_ID = "215783"

  def self.call(...)
    new(...).call
  end

  def initialize(keywords)
    @keywords = keywords
  end

  def call
    results = RakutenWebService::Ichiba::Product.search(keyword: @keywords, genreId: RAKUTEN_GENRE_ID)
    # 商品価格ナビ製品検索APIで商品が見つからなかったら楽天市場商品検索APIで再検索
    unless results.any?
      sleep(1) # 制限回避用
      results = RakutenWebService::Ichiba::Item.search(keyword: @keywords, genreId: RAKUTEN_GENRE_ID)
    end
    sleep(1) # 制限回避用
    results
  end
end
