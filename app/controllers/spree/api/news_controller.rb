class Spree::Api::NewsController < Spree::Api::BaseController
  def index
    @news = Spree::News.order(:updated_at)#.reverse
#    respond_with(@news)
  end
  
  def show
    @newsItem = Spree::News.last
#    respond_with(@newsItem)
  end
end
