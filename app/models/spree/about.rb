class Spree::About < ActiveRecord::Base
  has_many :pictures, as: :imageable, :dependent => :destroy
end
