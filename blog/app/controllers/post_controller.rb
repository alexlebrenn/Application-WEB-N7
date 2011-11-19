class PostController < ApplicationController
	
	#Page index => Page principal du blog
	#Affichage de tous les posts sous forme de liste
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
			format.js
    end
	end
	
	#Création de posts
	def create
		@post = Post.new
		@post.title = params[:title]
		@post.body = params[:body]
		@post.save
		
		respond_to do |format|
			format.html { redirect_to posts_path, notice: 'Post was successfully created.' }
      format.json { render json: @post, status: :created, location: @post }
			format.js
		end
	end
  def new
    @task = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task }
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

	#Suppression de posts
	def delete
		@post = Post.find(params[:id])
		@post.destroy

		respond_to do |format|
      format.html { redirect_to posts_path }
      format.json { head :ok }
    end
	end

end
