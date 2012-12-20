require 'open-uri'
require "digest/md5"
require 'carrierwave/processing/mini_magick'

class CircleImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :convert => 'png'

  # Create different versions of your uploaded files:
  version :circle_image do
    process :resize_to_fill => [815, 351]
  end



  version :circle_image_thumb do
    process :resize_to_fill => [120, 120]
  end



  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(jpg jpeg gif png)
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
