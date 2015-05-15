class Spree::Admin::NewsController < Spree::Admin::ResourceController 
  require 'net/http'
  #require 'net/https'

  helper_method :clone_object_url
  
  def index
    @item = Spree::News.order("updated_at DESC")
  end
  
  def new
    @item = Spree::News.new
  end
  
  def create
#    @newsItem = News.create(:title=>params[:title], :text => params[:text])
    @params = params
    @item = Spree::News.new ( news_params )
    if @item.save
      notify
      if params[:images]
        params[:images].each { |image|
          #@item.build_pictures if @item.pictures.blank?
          @item.pictures.create(image: image)
          #@item.save!
        }
      end
      redirect_to action:"index"
    else
      render :action => "new"
    end
  end

  def update
    if (params['id'].present? && !params['id'].blank?)
      @item = Spree::News.find(params['id'])
      @item.attributes = news_params
      if @item.save
        notify
        if params[:images]
          #@item.build_pictures if @item.pictures.blank?
          @item.pictures.delete_all
          params[:images].each { |image|
            @item.pictures.create(image: image)
            #@item.save!
          }
        end
        redirect_to action: "index"
      else
        render :action => "new"
      end
    end
  end
  
  private
  
  def find_resource
    @item = Spree::News.find_by(:id => params[:id])
  end
      
  def news_params
    params.require(:news).permit(:id, :imgName, :title, :text) #.permit(:username, :email, :password, :salt, :encrypted_password)
  end

#  def model_class
#    "#{controller_name.classify}".constantize
#  end

  def location_after_save
    spree.edit_admin_news_url(@item)
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
      data = {'title' => @item.title, 'text' => @item.text, 'app'=> {'android'=>'name.adec.android.shop', 'ios'=>'name.adec.ios.shop'}}
      request.body = data.to_json
      response = Net::HTTP.start(url.host, url.port) {|http| http.request(request) }
      flash[:notice] = Spree.t('news_sent')

    rescue Errno::EHOSTUNREACH
      flash[:error] = Spree.t('news_server_not_available') + ". " + Spree.t('news_not_sent') + "."
        # log the error
        # let the User @item
    rescue
      # handle other exceptions
      flash[:error] = Spree.t('unknown_error') + ". " + Spree.t('news_not_sent') + "."
    end
  end

end
