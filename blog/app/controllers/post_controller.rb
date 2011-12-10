class PostController < ApplicationController
	
	#Page index => Page principal du blog
	#Affichage de tous les posts sous forme de liste
	def index
		#if session[:person_id].nil?
			@posts = Post.all

		  respond_to do |format|
		    format.html
		    format.json { render json: @posts }
		  end
		#else
			#redirect_to(new_path)
		#end
  end

	#Affichage d'un post
	def show
		#@post = Post.find(params[:id])
    @post = Post.find(params[:id], :include => [{:comments => :person }])

 		respond_to do |format|
      format.html
      format.json { render json: @post }
			format.js
    end
	end
	
	#Création de posts
	def create
		@post = Post.new
		@post.title = params[:title]
		@post.body = params[:body]
		@post.person_id = session[:id]
		@post.save
		
		respond_to do |format|
			format.html { redirect_to posts_path, notice: 'Post was successfully created with session.' }
      format.json { render json: @post, status: :created, location: @post }
			format.js
		end
	end
  



	def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
      format.js # Task.new
    end
  end








	#Modification de posts
	def receive
		@post = Post.find(params[:id])
	end

	def modify
		@post = Post.find(params[:id])
		@post.title = params[:title]
		@post.body = params[:body]		
		@post.save

		respond_to do |format|
	    format.html { redirect_to show_path, notice: 'Post was successfully updated.' }
      format.json { head :ok }
    end
	end

 	# DELETE /posts/:id
	def delete
		@post = Post.find(params[:id])
		if check_author_post(@post.person_id, 'delete')
      @post.destroy
      @post = nil
		end

		respond_to do |format|
      format.html { redirect_to posts_path}
      format.json { head :ok }
    end
	end

#------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------

  def check_author_post(post_person_id, action)
    if post_person_id != session[:id]
      flash[:error] = "You can only #{action} posts you created"
      return false
    else
      return true
    end
  end

#------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------
end
