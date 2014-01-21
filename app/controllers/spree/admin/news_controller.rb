class Spree::Admin::NewsController < Spree::Admin::ResourceController 
  require 'net/http'
  #require 'net/https'

  helper_method :clone_object_url
  
  def index
    @news = News.order("updated_at DESC")
  end
  
  def new
    @newsItem = News.new #(news_params);
  end
  
  def create
#    @newsItem = News.create(:title=>params[:title], :text => params[:text])
    @params = params
    @newsItem = News.new ( news_params )

    if @newsItem.save
      notify
      redirect_to action:"index"
    else
      render :action => "new"
    end
  end

  def update
    @newsItem = News.new ( news_params )

    if @newsItem.save
      notify
      redirect_to action:"index"
    else
      render :action => "new"
    end
  end
  
  private
  
  def find_resource
    @newsItem = News.find_by(:id => params[:id])
  end
      
  def news_params
    params.require(:news).permit(:title, :text) #.permit(:username, :email, :password, :salt, :encrypted_password)
  end

  def model_class
    "#{controller_name.classify}".constantize
  end

  def location_after_save
    spree.edit_admin_news_url(@newsItem)
  end

  def clone_object_url resource
    clone_admin_news_url resource
  end

  def notify
    begin
      # problematic code

      #url = URI.parse('http://localhost:3000/notification/push/news')
      url = URI.parse('http://glacial-ridge-3064.herokuapp.com/notification/push/news')
      request = Net::HTTP::Post.new(url.path)
      request.content_type = 'application/json'
      data = {'title' => @newsItem.title, 'text' => @newsItem.text, 'app'=> {'android'=>'name.adec.android.shop', 'ios'=>'name.adec.ios.shop'}}
      request.body = data.to_json
      response = Net::HTTP.start(url.host, url.port) {|http| http.request(request) }
      flash[:notice] = Spree.t('news_sent')

    rescue Errno::EHOSTUNREACH
      flash[:error] = Spree.t('news_server_not_available') + ". " + Spree.t('news_not_sent') + "."
        # log the error
        # let the User know
    rescue
      # handle other exceptions
      flash[:error] = Spree.t('unknown_error') + ". " + Spree.t('news_not_sent') + "."
    end
  end

end
