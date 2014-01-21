object false
child(@contacts => :contacts) do
 extends "spree/api/contacts/show"
end

node(:count) { @contacts.count }
node(:current_page) { params[:page] || 1 }
