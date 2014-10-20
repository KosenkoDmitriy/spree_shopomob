
class AddTenantIdToShopomobModels < ActiveRecord::Migration
  def change
    tables = [
        "spree_abouts",
        "spree_news",
        "spree_syncs",
        "spree_sms",
        "spree_contacts",
    ]
    tables.each do |table|
      add_column table, :store_id, :integer, index: true
    end
    #tables.each do |table|
    #  add_column table, :store_id, :integer
    #  add_index table, :store_id
    #end
  end
end
