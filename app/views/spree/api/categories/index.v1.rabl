object false
child(@taxons => :taxons) do
 extends "spree/api/categories/show"
end

node(:count) { @taxons.count }
node(:current_page) { params[:page] || 1 }
