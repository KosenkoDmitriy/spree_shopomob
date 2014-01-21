class Spree::Api::AboutController < Spree::Api::BaseController
  def index
    @about = About.last # About.where(id:7)
#            @about = About.ransack(params[:q]).result.page(params[:page]).per(params[:per_page])
    respond_with(@about)

  end
end


