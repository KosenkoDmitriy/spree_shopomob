class Spree::Picture < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "150x150>" }, :default_url => "/assets/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  def image_url_thumb
    image.url(:thumb)
  end
  def image_url
    image.url(:medium)
  end
  def image_url_original
    image.url(:original)
  end
end
