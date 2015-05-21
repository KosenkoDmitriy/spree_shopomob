object false
child(@products => :products) do
 extends "spree/api/categories/product"
end

node(:total_count) { @total_count}
node(:count) { @products.count }
node(:current_page) { params[:page] || 1 }
