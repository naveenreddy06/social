require 'carrierwave/processing/mini_magick'
class ProfileImageUploader < CarrierWave::Uploader::Base
include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :convert => 'png'

  # Create different versions of your uploaded files:
  version :profile_image do
    process :resize_to_fill => [120, 120]
  end

  version :profile_image_thumb do
    process :resize_to_fill => [32, 32]
  end

  version :profile_image_thumb_small do
    process :resize_to_fill => [40, 40]
  end

  # Used for chronicle profile image
  version :profile_image_thumb_small_chronicle do
    process :resize_to_fill => [20, 20]
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
