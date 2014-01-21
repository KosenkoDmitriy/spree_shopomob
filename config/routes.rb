Spree::Core::Engine.routes.draw do
  # Add your extension routes here
end

Spree::Core::Engine.routes.append do
  namespace :admin do
    resources :about
    resources :news
    resources :contacts
    resources :sms
    resources :sync
  end
  
  namespace :api, :defaults => { :format => 'json' } do
    resources :about
    resources :contacts
    resources :news
  end
  
end
