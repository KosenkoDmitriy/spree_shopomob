object false
child(@news => :news) do
 extends "spree/api/news/show"
end

node(:total_count) { @total_count }
node(:count) { @news.count }
node(:current_page) { params[:page] || 1 }

