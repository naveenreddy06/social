require 'open-uri'
require "digest/md5"
require 'carrierwave/processing/mini_magick'
class FeedImageUploader < CarrierWave::Uploader::Base
include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :convert => 'png'

  # Create different versions of your uploaded files:
  version :feedimage do
    process :resize_to_fit => [480, 300]
  end

  version :feedzoom do
    process :resize_to_fit => [800, nil]
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

