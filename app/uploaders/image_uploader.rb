# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  include CarrierWave::MiniMagick

  process :resize_to_limit => [640, 640]

  version :thumb do
    process :resize_to_fill => [80, 80]
  end
  
  version :medium do
    process :resize_to_limit => [150, 150]
  end
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
