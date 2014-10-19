class Spree::Admin::ShopController < Spree::Admin::BaseController

  respond_to :html, :json, :js

  def search
    if params[:ids]
      @shops = Spree::Shop.where(:id => params[:ids].split(','))
    else
      @shops = Spree::Shop.limit(20).ransack(:name_cont => params[:q]).result
    end
  end

  def create
    @category = Category.find(params[:taxonomy_id])
    @shop = @category.shops.build(params[:shop])
    if @shop.save
      respond_with(@shop) do |format|
        format.json {render :json => @shop.to_json }
      end
    else
      flash[:error] = Spree.t('errors.messages.could_not_create_taxon')
      respond_with(@shop) do |format|
        format.html { redirect_to @category ? edit_admin_taxonomy_url(@category) : admin_taxonomies_url }
      end
    end
  end

  def edit
    @category = Category.find(params[:taxonomy_id])
    @shop = @category.shops.find(params[:id])
    @permalink_part = @shop.permalink.split("/").last
  end

  def update
    @category = Category.find(params[:taxonomy_id])
    @shop = @category.shops.find(params[:id])
    parent_id = params[:shop][:parent_id]
    new_position = params[:shop][:position]

    if parent_id
      @shop.parent = Shop.find(parent_id.to_i)
    end

    if new_position
      @shop.child_index = new_position.to_i
    end

    @shop.save!

    # regenerate permalink
    if parent_id
      @shop.reload
      @shop.set_permalink
      @shop.save!
      @update_children = true
    end

    if params.key? "permalink_part"
      parent_permalink = @shop.permalink.split("/")[0...-1].join("/")
      parent_permalink += "/" unless parent_permalink.blank?
      params[:shop][:permalink] = parent_permalink + params[:permalink_part]
    end
    #check if we need to rename child shops if parent name or permalink changes
    @update_children = true if params[:shop][:name] != @shop.name || params[:shop][:permalink] != @shop.permalink

    if @shop.update_attributes(taxon_params)
      flash[:success] = flash_message_for(@shop, :successfully_updated)
    end

    #rename child shops
    if @update_children
      @shop.descendants.each do |shop|
        shop.reload
        shop.set_permalink
        shop.save!
      end
    end

    respond_with(@shop) do |format|
      format.html {redirect_to edit_admin_taxonomy_url(@category) }
      format.json {render :json => @shop.to_json }
    end
  end

  def destroy
    @shop = Shop.find(params[:id])
    @shop.destroy
    respond_with(@shop) { |format| format.json { render :json => '' } }
  end

  private
  def taxon_params
    params.require(:shop).permit(permitted_params)
  end

  def permitted_params
    Spree::PermittedAttributes.taxon_attributes
  end
end
