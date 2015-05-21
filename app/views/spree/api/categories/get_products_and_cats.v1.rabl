object false
node(:total_count) { @items.count }
node(:count) { @items.count }
node(:current_page) { params[:page] || 1 }
node(:items) { @items }