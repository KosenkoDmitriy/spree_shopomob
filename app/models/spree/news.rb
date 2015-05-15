class Spree::News < ActiveRecord::Base
  validates(:title, presence: true)
  validates(:text, presence: true)

  has_many :pictures, as: :imageable, :dependent => :destroy
end
