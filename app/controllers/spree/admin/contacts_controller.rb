class Spree::Admin::ContactsController < Spree::Admin::ResourceController 

  private
  def model_class
    "#{controller_name.classify}".constantize
  end
end
