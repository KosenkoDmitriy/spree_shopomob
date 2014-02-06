class Spree::Api::CategoriesController < Spree::Api::BaseController
  def index
    @taxons = Spree::Taxon.order(:taxonomy_id, :lft)
#    respond_with(@taxons)
  end
  def show
    @taxon = Spree::Taxon.find(params[:id])
#    respond_with(@taxon)
  end
end
