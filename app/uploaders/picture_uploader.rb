class PictureUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave

  version :standard do
    process :resize_to_fill => [1000, 600, :north]
  end
end
