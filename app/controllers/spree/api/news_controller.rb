class Spree::Api::NewsController < Spree::Api::BaseController
  def index
    @news = News.order(:updated_at)#.reverse
#    respond_with(@news)
  end
  
  def show
    @newsItem = News.last
#    respond_with(@newsItem)
  end
end
