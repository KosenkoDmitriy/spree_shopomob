Spree::Core::Engine.routes.draw do
  # Add your extension routes here

  namespace :admin do
    resources :about
    resources :news
    resources :contacts
    resources :sms
    resources :sync

    resources :shop
    #resources :category # shop categories
    #resources :categories # shop categories
    #resources :company
    resources :categories

  end

  namespace :api, :defaults => { :format => 'json' } do
    resources :about
    resources :contacts
    resources :news
    resources :categories # product categories
    match '/get_products_by_category_id/:id',    to: 'categories#get_products_by_category_id',    via: 'get'
    #match '/get_products_by_category_id',    to: 'categories#products_by_category_id',    via: 'get'

  end

end
