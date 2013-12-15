SecretSanta::Application.routes.draw do
	get '/event/:event_hash', to: 'events#show'
	get '/event/:event_hash/join_event', to: 'events#join_event'
	get '/event/:event_hash/start_event', to: 'events#start_event'
	get '/event/:event_hash/stop_event', to: 'events#stop_event'
	get '/event/:event_hash/edit', to: 'events#edit'
	put '/event/:event_hash/update', to: 'events#update'
	get '/events', to: 'events#show_events'

	get '/user/log_out', to: 'users#log_out'

  resources :users

  resources :events

	get '/auth/:provider/callback', to: 'users#create_from_facebook'
	get '/create_event', to: 'users#create_new_event'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'events#index'

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
