#class Spree::Category < ActiveRecord::Base
#end
module Spree
  class Category < ActiveRecord::Base
    #validates :title, presence: true
    #
    #has_many :shops
    #has_one :root, -> { where parent_id: nil }, class_name: "Spree::Shop", dependent: :destroy
    #
    #after_save :set_title
    #
    #default_scope -> { order("#{self.table_name}.position") }
    #
    #private
    #def set_title
    #  if root
    #    root.update_column(:title, title)
    #  else
    #    self.root = Category.create!(category_id: id, title: title)
    #  end
    #end

    validates :title, presence: true

    has_many :shop
    #has_one :root, -> { where parent_id: nil }, class_name: "Spree::Taxon", dependent: :destroy

    #after_save :set_name

    default_scope -> { order("#{self.table_name}.position") }

    private
    def set_name
      if root
        root.update_column(:name, name)
      else
        self.root = Taxon.create!(taxonomy_id: id, name: name)
      end
    end


  end
end