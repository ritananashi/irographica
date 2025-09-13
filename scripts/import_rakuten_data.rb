product_all = Product.where.not("name LIKE ?", "%オリジナル%")

import_rakuten_data = product_all.all.map { |product| RakutenDataFetchJob.new(product.id) }
ActiveJob.perform_all_later(import_rakuten_data)
