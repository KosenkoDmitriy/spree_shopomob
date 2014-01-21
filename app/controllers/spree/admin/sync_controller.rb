class Spree::Admin::SyncController < Spree::Admin::ResourceController 
  require 'net/http'
  #require 'net/https'

  helper_method :clone_object_url
  
  def index
    @news = Spree::Sync.order("datetime(updated_at) DESC")
  end
  
  def new
    @newsItem = Spree::Sync.new #(news_params);
  end
  
  def show
    @newsItem = Spree::Sync.find_by(:id => params[:id])
  end
  def edit
    @newsItem = Spree::Sync.find_by(:id => params[:id])
  end
  
  def create
#    @newsItem = News.create(:title=>params[:title], :text => params[:text])
    @params = params
    @newsItem = Spree::Sync.new ( sync_params )
    if @newsItem.save
      flash[:notice] = t('news_successfully_submitted')
      #redirect_to ("index") #(product_path(@product))
      
#      url = URI.parse('http://localhost:3000/notification/push/sync')
      url = URI.parse('http://glacial-ridge-3064.herokuapp.com/notification/push/sync')
      request = Net::HTTP::Post.new(url.path)
      request.content_type = 'application/json'
      data = {'sync' => @newsItem.options, 'title' => @newsItem.title, 'text' => @newsItem.text, 'app'=> {'android'=>'name.adec.android.shop', 'ios'=>'name.adec.ios.shop'}}
      request.body = data.to_json
      response = Net::HTTP.start(url.host, url.port) {|http| http.request(request) }

      redirect_to action:"index"
#      redirect_to news_path
    else
      render :action => "new"
    end
  end
  
  private
    def collection_url
      '/admin/sync'
    end
  
    def sync_params
      params.require(:sync).permit(:title, :text, :options, :app_id)
    end

end
