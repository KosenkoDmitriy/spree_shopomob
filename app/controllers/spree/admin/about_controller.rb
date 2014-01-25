class Spree::Admin::AboutController < Spree::Admin::ResourceController #ApplicationController
  
  def index
    @about = Spree::About.last
    if (@about) 
      @edit_about_url = collection_url + "/" + @about.id.to_s + "/edit"
    end
    #session[:return_to] = request.url
    #respond_with(@collection)
  end
#
#  
#  def create
##    @aboutOld = Spree::About.find(abouts_params)
##    @about = Spree::About.new(abouts_params)
##    if (@about.title == @aboutOld.text && @about.title == @aboutOld.title)
#    if Spree::About.create(abouts_params)
#        redirect_to action:"index"
#    else
#        redirect_to action:"new"
#    end
#  end

  private
#  def model_class
#    "#{controller_name.classify}".constantize
#  end
  
#  def object_name
#    "about"
#  end
  
  def abouts_params
    params.require(:about).permit(:title, :text) #.permit(:username, :email, :password, :salt, :encrypted_password)
  end
  
#  def find_resource
#      @aboutLast = Spree::About.find_by(:id => params[:id])
#  end
   def collection_url(options = {})
#      if parent_data.present?
#        spree.polymorphic_url([:admin, parent, model_class], options)
#      else
#        spree.polymorphic_url("admin_about")
#      end
      "/admin/about"
  end
  
  
end
