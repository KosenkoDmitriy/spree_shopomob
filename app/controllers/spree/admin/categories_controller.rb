class Spree::Admin::CategoriesController < Spree::Admin::ResourceController
  #respond_to :json, :only => [:get_children]

  #def get_children
  #  @shops = Shop.find(params[:parent_id]).children
  #end

  def index
    @categories = Spree::Category.all
  end

  def new
    @category = Spree::Category.new
  end

  def update
    @category = Spree::Category.find(params[:id])
    @category.attributes = news_params
    if @category.save
      redirect_to action:"index"
    else
      render :action => "new"
    end
  end

  def get_children
    @shops = Shop.find(params[:parent_id]).children
  end

  def create
#    @newsItem = News.create(:title=>params[:title], :text => params[:text])
    @params = params
    @category = Spree::Category.new ( news_params )

    if @category.save
      #notify
      redirect_to action:"index"
    else
      render :action => "new"
    end
  end

  private

  def news_params
    #params.require(:category).permit(:id, :imgName, :title, :text) #.permit(:username, :email, :password, :salt, :encrypted_password)
    params.require(:category).permit(:id, :imgName, :title, :text) #.permit(:username, :email, :password, :salt, :encrypted_password)
  end

  def location_after_save
    if @category.created_at == @category.updated_at
      edit_admin_category_url(@category)
    else
      admin_categories_url
    end
  end

end
