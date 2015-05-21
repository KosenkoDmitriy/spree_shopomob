class Spree::Api::AboutController < Spree::Api::BaseController
  def index
    @about = Spree::About.last # About.where(id:7)
#            @about = About.ransack(params[:q]).result.page(params[:page]).per(params[:per_page])
#    respond_with(@about)

  end

  def is_online
    #respond_with("true")
    #return;
    @is_online ="true"
  end
end


