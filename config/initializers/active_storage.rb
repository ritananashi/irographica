# S3の画像をデフォルトでプロキシモードで使用する用の設定
Rails.application.config.active_storage.resolve_model_to_route = :cdn_image
