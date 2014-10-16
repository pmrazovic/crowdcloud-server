Rails.application.routes.draw do
  devise_for :accounts

  resources :devices, :only => [:index, :show, :destroy] do
    member do
      get 'unregister'
      get 'sensors'
      get 'responses'
      get 'statistics'
      get 'compose_message'
      post 'push_message'
    end
  end

  resources :open_calls do
    member do
      get 'delete'
      get 'confirm_publish'
      get 'devices'
      post 'publish'
    end
    resources :responses, :only => [:index, :show]
  end

  root 'devices#index'

  # API routes ---------------------------------------

  get  'api/open_calls' => 'open_calls#list_open_calls'
  get  'api/open_calls/:id' => 'open_calls#get_open_call'
  post 'api/open_calls/:id/responses' => 'responses#create'
  post 'api/devices/register' => 'devices#register'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
