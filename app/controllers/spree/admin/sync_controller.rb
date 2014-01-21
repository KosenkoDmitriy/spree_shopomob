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
      notify
      redirect_to action:"index"
    else
      render :action => "new"
    end
  end

  def update
    @newsItem = Spree::Sync.new ( sync_params )

    if @newsItem.save
      notify
      redirect_to action:"index"
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

  def notify
    begin
      # problematic code

      #      url = URI.parse('http://localhost:3000/notification/push/sync')
      url = URI.parse('http://glacial-ridge-3064.herokuapp.com/notification/push/sync')
      request = Net::HTTP::Post.new(url.path)
      request.content_type = 'application/json'
      data = {'sync' => @newsItem.options, 'title' => @newsItem.title, 'text' => @newsItem.text, 'app'=> {'android'=>'name.adec.android.shop', 'ios'=>'name.adec.ios.shop'}}
      request.body = data.to_json
      response = Net::HTTP.start(url.host, url.port) {|http| http.request(request) }

      flash[:notice] = Spree.t('status.successfully')

    rescue Errno::EHOSTUNREACH
      flash[:error] = Spree.t('news_server_not_available') + ". " + Spree.t('sync_error') + "."
        # log the error
        # let the User know
    rescue
      # handle other exceptions
      flash[:error] = Spree.t('unknown_error') + ". " + Spree.t('sync_error') + "."
    end
  end

end
