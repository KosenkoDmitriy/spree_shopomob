class Spree::Api::NewsController < Spree::Api::BaseController
  def index
    limit1 = params[:page].to_i
    limit2 = params[:per_page].to_i
    if (limit1 > 0)
      limit1 = limit1*limit2
    end
    if (limit2 > 0)
      @news = Spree::News.order(:updated_at).offset(limit1).limit(limit2).reverse
    else
      @news = Spree::News.order(:updated_at).reverse
    end
    @total_count = Spree::News.count
#    respond_with(@news)
  end
  
  def show
    @newsItem = Spree::News.last
#    respond_with(@newsItem)
  end
end
