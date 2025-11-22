module ProcessImages
  extend ActiveSupport::Concern

  def process_images(images)
    return [] unless images&.present?

    images.filter_map do |image|
      begin
        processed_image = ImageProcessing::MiniMagick.source(image.tempfile).resize_to_fit(700, 700).convert("webp").call
        {
          io: processed_image,
          filename: "#{File.basename(image.original_filename, ".*")}.webp",
          content_type: "image/webp"
        }
      rescue => e
        Rails.logger.error("画像処理エラー: #{e.message}")
        nil
      end
    end
  end
end
