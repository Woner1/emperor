class User < ApplicationRecord
  mount_uploader :image, UserUploader

  def image_thumb_url
    image.thumb.url
  end

  def image_small_url
    image.small.url
  end

  def image_medium_url
    image.medium.url
  end
end
