object false
child(@products => :products) do
 extends "spree/api/categories/product"
end

node(:count) { @products.count }
node(:current_page) { params[:page] || 1 }
