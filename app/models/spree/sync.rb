class Spree::Sync < ActiveRecord::Base
  validates(:title, presence: true)
  validates(:text, presence: true)
  validates(:app_id, presence: true)
  validates(:options, presence: true)
end
