class Spree::Admin::AboutsController < Spree::Admin::ResourceController

  def index
    @item = Spree::About.last
  end

  def edit
    @item = Spree::About.find(params[:id])
  end

  def new
    @item = Spree::About.new
  end

  def update
    @item = Spree::About.find(params[:id])
    @item.attributes = abouts_params

    if @item.save
      if params[:images]
        params[:images].each { |image|
          @item.build_pictures if @item.pictures.blank?
          @item.pictures.create(image: image)
          @item.save!
        }
      end
      redirect_to action: "index"
    else
      render :action => "new"
    end
  end


  def create
    @item = Spree::About.new ( abouts_params )
    if @item.save
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


  private

  def abouts_params
    params.require(:about).permit(:title, :text) #.permit(:username, :email, :password, :salt, :encrypted_password)
  end
end
