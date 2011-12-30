class PostController < ApplicationController
	
	before_filter :authenticate, :except => [:index, :show]

	#Page index => Page principal du blog
	def index
			@posts = Post.all

		  respond_to do |format|
		    format.html
		    format.json { render json: @posts }
		  end
  end


	#Affichage d'un post
	def show
		@post = Post.find(params[:id])

 		respond_to do |format|
      format.html
      format.json { render json: @post }
    end
	end
	

	def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end


	#Création de posts
	def create
		@post = Post.new
		@post.title = params[:title]
		@post.body = params[:body]
		if session[:id]
			@post.person_id = session[:id]
		end

		if @post.save
      respond_to do |format|
        flash[:notice] = "Post was successfully created with session."
        format.html { redirect_to(posts_path) }
      end
    else
      respond_to do |format|
        flash[:error] = "Post can\'t be created."
        format.html { render :action => "new" }
      end
    end
	end


	def receive
		@post = Post.find(params[:id])
	end


	#Modification de posts
	def modify
		@post = Post.find(params[:id])
		@post.title = params[:title]
		@post.body = params[:body]		
		@post.save

		if @post.save
      respond_to do |format|
        flash[:notice] = "Post was successfully updated."
        format.html { redirect_to(show_path(@post.id)) }
      end
    else
      respond_to do |format|
        flash[:error] = "Post can\'t be updated."
        format.html { render :action => "receive" }
      end
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
