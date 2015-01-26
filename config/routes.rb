Rails.application.routes.draw do
  devise_for :accounts, :controllers => { registrations: 'registrations' }

  resources :devices, :only => [:index, :show, :destroy] do
    member do
      get 'unregister'
      get 'sensors'
      get 'statistics'
      get 'responses'
      get 'compose_message'
      post 'push_message'
    end
  end

  resources :sensing_tasks do
    member do
      get 'delete'
      get 'confirm_publish'
      get 'devices'
      post 'publish'
      get 'sensing_responses'
      get 'sensing_response_details'
    end
  end

  resources :sensing_responses, :only => [:show]

  resources :hits do
    member do
      get 'delete'
      get 'confirm_publish'
      get 'devices'
      post 'publish'
      get 'step_2'
      get 'confirm_step_2'
      get 'step_3'
      put 'confirm_step_3'
      get 'step_4'
      put 'confirm_step_4'
      get 'finish_formulation'
      get 'manage_hit_choices'
      get 'responses'
    end
    collection do
      get 'step_1'
      post 'confirm_step_1'
    end
  end

  resources :hit_choices

  root 'devices#index'

  # API routes ---------------------------------------

  get  'api/sensing_tasks' => 'sensing_tasks#list_sensing_tasks'
  get  'api/sensing_tasks/:id' => 'sensing_tasks#get_sensing_task'
  post 'api/sensing_tasks' => 'sensing_tasks#publish_new'
  get  'api/fetch_sensing_data_types' => 'sensing_tasks#fetch_sensing_data_types'
  get  'api/hits' => 'hits#list_hits'
  get  'api/hits/:id' => 'hits#get_hit'
  post 'api/sensing_responses' => 'sensing_responses#create'
  post 'api/hit_responses' => 'hit_responses#create'
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
