class Spree::Contact < ActiveRecord::Base
  validates(:key, presence: true)
  validates(:value, presence: true)
  validates(:prefix, presence: false)
  validates(:contact_type, presence: true)

  has_one :picture, as: :imageable, :dependent => :destroy

end
