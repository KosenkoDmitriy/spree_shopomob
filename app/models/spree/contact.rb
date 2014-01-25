class Spree::Contact < ActiveRecord::Base
  validates(:key, presence: true)
  validates(:value, presence: true)
  validates(:prefix, presence: true)
  validates(:contact_type, presence: true)

end
