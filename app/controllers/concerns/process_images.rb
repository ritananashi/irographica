module ProcessImages
  extend ActiveSupport::Concern

  def process_images(params)
    processed_params = []
    params[:images].each do |image|
      processed_image = ImageProcessing::MiniMagick.source(image.tempfile).resize_to_fit(700, 700).convert("webp").call
      processed_params << {
        io: processed_image,
        filename: "#{File.basename(image.original_filename, ".*")}.webp",
        content_type: "image/webp"
      }
    end
    processed_params
  end
end
