require 'open-uri'
require "digest/md5"
require 'carrierwave/processing/mini_magick'
class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file


  process :convert => 'png'

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fill => [120, 120]
  end

  version :wall_banner do
    process :resize_to_fill => [700, 220]
  end

  version :thumb_nail do
    process :resize_to_fill => [60, 60]
  end

    version :thumb_nail_small do
    process :resize_to_fill => [40, 40]
  end

  # Override the filename of the uploaded files:
  # see http://huacnlee.com/blog/carrierwave-upload-store-file-name-config/
  def filename
    if super.present?

      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension.downcase}"
    end
  end


end

