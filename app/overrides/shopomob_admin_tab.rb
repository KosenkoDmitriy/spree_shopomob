Deface::Override.new(:virtual_path => "spree/admin/shared/_menu",
                     :name => "shopomob_admin_tab",
                     :insert_bottom => "[data-hook='admin_tabs']",
                     :text => "<%= tab :about, :label => 'Shopomob', :url => '/admin/about', :icon => 'icon-shopping-cart' %>",
                     :disabled => false)
