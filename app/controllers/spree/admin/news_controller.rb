class Spree::Admin::NewsController < Spree::Admin::ResourceController 
  require 'net/http'
  #require 'net/https'

  helper_method :clone_object_url
  
  def index
    @news = News.order("datetime(updated_at) DESC")
  end
  
   def new
#    @review = Spree::Review.new(:title => params[:title], :text => params[:text])
    @newsItem = News.new #(news_params);
  end
  
  def create
#    @newsItem = News.create(:title=>params[:title], :text => params[:text])
    @params = params
    @newsItem = News.new ( news_params )
    if @newsItem.save
      flash[:notice] = t('news_successfully_submitted')
      #redirect_to ("index") #(product_path(@product))
      
#      url = URI.parse('http://localhost:3000/notification/push/news')
      url = URI.parse('http://glacial-ridge-3064.herokuapp.com/notification/push/news')
      request = Net::HTTP::Post.new(url.path)
      request.content_type = 'application/json'
      data = {'title' => @newsItem.title, 'text' => @newsItem.text, 'app'=> {'android'=>'name.adec.android.shop', 'ios'=>'name.adec.ios.shop'}}
      request.body = data.to_json
      response = Net::HTTP.start(url.host, url.port) {|http| http.request(request) }

      redirect_to action:"index"
#      redirect_to news_path
    else
      render :action => "new"
    end
  end
  
#  def show
#        session[:return_to] ||= request.referer
#        redirect_to( :action => :edit )
#      end
  
#  def clone
#    @new = @newsItem.duplicate
#
#    if @new.save
#      flash[:success] = Spree.t('notice_messages.product_cloned')
#    else
#      flash[:success] = Spree.t('notice_messages.product_not_cloned')
#    end
#
#    redirect_to edit_admin_news_url(@new)
#  end
  
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

#    def model_name
#      parent_data[:model_name].gsub('spree/', '')
#    end
##
#    def object_name
#      controller_name.singularize
#    end

  
#    def location_after_new
#      spree.admin_news_url(@newsItem)
#    end
    
  def location_after_save
    spree.edit_admin_news_url(@newsItem)
  end
  

  def clone_object_url resource
    clone_admin_news_url resource
  end
      
end
