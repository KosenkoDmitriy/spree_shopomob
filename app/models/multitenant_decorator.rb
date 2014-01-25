models = [
  Spree::About,
  Spree::News,
  Spree::Sync,
  Spree::Sms,
  Spree::Contact,
]
models.each do |model|
  model.class_eval do
    belongs_to :tenant
    belongs_to_multitenant
  end
end
