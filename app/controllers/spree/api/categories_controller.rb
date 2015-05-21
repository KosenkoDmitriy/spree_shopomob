class Spree::Api::CategoriesController < Spree::Api::BaseController

  def index
    id = params[:id].to_i
    per_page = params[:per_page].to_i
    if (per_page <= 0)
      @taxons = Spree::Taxon.order(:taxonomy_id, :lft)
      respond_with(@taxons)
      return
    end

    if (id > 0)
      if (Spree::Taxonomy.exists?(id))
        @taxonomy = Spree::Taxonomy.find(id)
        @taxons = Spree::Taxon.where(taxonomy_id: @taxonomy.id, parent_id: @taxonomy.id)#.order(:name, :lft) #commented order because {"exception":"SQLite3::SQLException: no such column: spree_taxon_translations.name: SELECT \"spree_taxons\".* FROM \"spree_taxons\" WHERE \"spree_taxons\".\"taxonomy_id\" = ? AND \"spree_taxons\".\"parent_id\" = ?  ORDER BY spree_taxon_translations.name"}
      elsif (Spree::Taxon.where(parent_id: id).exists?) #searching subcats
        @taxons = Spree::Taxon.where(parent_id: id)
      else
        @taxons = Spree::Taxon.where(taxonomy_id: id, parent_id: id)#.order(:name, :lft) #commented order because {"exception":"SQLite3::SQLException: no such column: spree_taxon_translations.name: SELECT \"spree_taxons\".* FROM \"spree_taxons\" WHERE \"spree_taxons\".\"taxonomy_id\" = ? AND \"spree_taxons\".\"parent_id\" = ?  ORDER BY spree_taxon_translations.name"}
      end
    elsif (id == 0)
      @taxons = Spree::Taxon.where(parent_id:nil)
    else
      @taxons = Spree::Taxon.order(:taxonomy_id, :lft)
    end


    #if (@taxons.present?)
    #respond_with(@taxons)
    #respond_to do |format|
    #  format.json { render :json => @taxons }
    #end

    respond_with(@taxons)
    return
    #respond_to do |format|
    #  format.json { render :json => {} }
    #end
  end

  def show
    @taxon = Spree::Taxon.find(params[:id])
#    respond_with(@taxon)
  end

  def get_products_by_category_id
    id = params[:id].to_i
    limit1 = params[:page].to_i
    limit2 = params[:per_page].to_i
    per_page = params[:per_page].to_i

    @total_count = Spree::Product.count
    if (limit2 <= 0)
      @products = Spree::Product.order(:updated_at)
      respond_with(@products)
      return
    end

    if (id > 0)
      @taxon = Spree::Taxon.find(params[:id])
      @products = @taxon.products.offset(limit1).limit(limit2)

    else
      @products = Spree::Product.order(:updated_at).offset(limit1).limit(limit2)
    end

    #@product = Spree::Product.first

    #@products = @taxon.products
    #if (@taxon.products.count > 0)
    #  respond_with(@taxon.products)
    #end
  end

  def get_products_and_cats
    @items = []
    Spree::Product.all.each do |product|
      if (product.taxon_ids.count>0)
        product.taxon_ids.each {|cat_id| @items << { pid: product.id, cid: cat_id }}
      end
    end
  end

end
