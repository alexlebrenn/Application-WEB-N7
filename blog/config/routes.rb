Blog::Application.routes.draw do
  get "post/index"

	get "/posts", 															:controller => :post, :action => :index
	get "/posts/new", 													:controller => :post, :action => :new, 				:as => :new
	get "/posts/:id", 													:controller => :post, :action => :show, 			:as => :show
	post "/posts", 															:controller => :post, :action => :create
	delete "/post/delete/:id", 									:controller => :post, :action => :delete, 		:as => :delete
	post "/posts/modify/:id",										:controller => :post, :action => :receive, 		:as => :receive
	put "/posts/:id", 													:controller => :post, :action => :modify, 		:as => :modify



	get "/posts/:id/comments/new",							:controller => :comments, :action => :new, 		:as => :new_post_comment
	get "/posts/:id/comments/:comment_id", 			:controller => :comments, :action => :show, 	:as => :post_comment
	post "/posts/:id/comments", 								:controller => :comments, :action => :create, :as => :create_post_comment
	delete "/posts/:id/comments/:comment_id", 	:controller => :comments, :action => :delete,:as => :delete_post_comment
	get "/posts/:id/comments/:comment_id/edit",	:controller => :comments, :action => :edit, 	:as => :edit_post_comment
	put "/posts/:id/comments/:comment_id", 			:controller => :comments, :action => :update, :as => :update_post_comment



	get "/posts/person/login", 									:controller => :people, :action => :login,		:as => :login_person
	post "/posts/person/login", 								:controller => :people, :action => :login
	get "/posts/person/:person_id/logout",			:controller => :people, :action => :logout,		:as => :logout_person
	get "/posts/person/new",										:controller => :people, :action => :new, 			:as => :new_person
	get "/posts/person/:person_id",							:controller => :people, :action => :show, 		:as => :show_person
	post "/posts/person", 											:controller => :people, :action => :create,		:as => :create_person
	delete "/posts/person/:person_id",				 	:controller => :people, :action => :delete, 	:as => :delete_person
	get "/posts/person/:person_id/edit",				:controller => :people, :action => :edit, 		:as => :edit_person
	put "/posts/person/:person_id",							:controller => :people, :action => :update, 	:as => :update_person

	resources :posts do
		resources :comments
	end
end
