Blog::Application.routes.draw do
  get "post/index"

	get "/posts", 								:controller => :post, :action => :index
	get "/posts/new", 						:controller => :post, :action => :new, 			:as => :new
	get "/posts/:id", 						:controller => :post, :action => :show, 		:as => :show
	post "/posts", 								:controller => :post, :action => :create
	delete "/post/delete/:id", 		:controller => :post, :action => :delete, 	:as => :delete
	post "/posts/modify/:id",			:controller => :post, :action => :receive, 	:as => :receive
	put "/posts/:id", 						:controller => :post, :action => :modify, 	:as => :modify

	get "/posts/:id", 													:controller => :comments, :action => :indexcomment
	get "/posts/:id/comments/new",							:controller => :comments, :action => :new, 		:as => :new_post_comment
	get "/posts/:id/comments/:comment_id", 			:controller => :comments, :action => :show, 	:as => :post_comment
	post "/posts/:id/comments", 								:controller => :comments, :action => :create, :as => :create_post_comment
	delete "/posts/:id/comments/:comment_id", 	:controller => :comments, :action => :delete, :as => :delete_post_comment
	get "/posts/:id/comments/:comment_id/edit",:controller => :comments, :action => :edit, 	:as => :edit_post_comment
	put "/posts/:id/comments/:comment_id", 			:controller => :comments, :action => :update, :as => :update_post_comment


	resources :posts do
		resources :comments
	end
 
	# Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
