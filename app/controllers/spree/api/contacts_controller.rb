class Spree::Api::ContactsController < Spree::Api::BaseController
  def index
    @contacts = Spree::Contact.order(:id)
#    @contacts = Spree.user_class.accessible_by(current_ability,:read).ransack(params[:q]).result.page(params[:page]).per(params[:per_page])

#    respond_with(@contacts)
  end
  
  def show
    @contact = Spree::Contact.find(params[:id])
#    respond_with(contact)
  end
  
  private

#  def contact
#    @contact = Contact.last
##    @contact ||= Spree.user_class.accessible_by(current_ability, :read).find(params[:id])
#  end
end
