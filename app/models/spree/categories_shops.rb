class Spree::CategoriesShops < ActiveRecord::Base
  self.table_name = 'spree_categories_shops'
  belongs_to :shop, class_name: "Spree::Shop"
  belongs_to :category, class_name: "Spree::Category"

  # For #3494
  validates_uniqueness_of :category_id, :scope => :shop_id, :message => :already_linked

end
