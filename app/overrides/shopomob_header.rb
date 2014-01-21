#Deface::Override.new(:virtual_path => "spree/admin/shared/_header",
#                     :name => "shopomob_header",
#                     :insert_bottom => "[data-hook='logo-wrapper']",
##                     :replace => "#logo",
#                     :text => "<%= link_to image_tag('/images/logo.jpg', :id => 'logo'), spree.admin_path %>",
#                     #:text => "<%#= link_to image_tag('/assets/logo.jpg', :id => 'logo'), spree.admin_path %>",
#                     :disabled => false)
#Deface::Override.new(:virtual_path => "spree/shared/_header", 
#                     :name => "logo", 
#                     :replace_contents => "#logo", 
#                     :text => 
#"<img src=\"app/assets/images/logo.jpg\" alt=\"Your logo here\" />")