object false
child(@taxons => :news) do
 extends "spree/api/categories/show"
end

node(:count) { @taxons.count }
node(:current_page) { params[:page] || 1 }
