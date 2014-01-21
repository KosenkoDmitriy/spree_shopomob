class Sms < ActiveRecord::Base
  validates(:to, presence: true)
  validates(:from, presence: true)
  validates(:text, presence: true)
  validates(:userapp, presence: true)
end
