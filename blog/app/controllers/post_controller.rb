class PostController < ApplicationController
	
	#Page index => Page principal du blog
	# Permet l'affichage de tous les posts  
	def index
		@posts = Post.all
  end

	def show
		@post = Post.find(params[:id])
	end
	
	#Page de création de posts
	def create
		@post = Post.new
		@post.title = params[:title]
		@post.body = params[:body]		
		@post.save
		redirect_to posts_path
	end

	#Page de modification de posts
	def receive
		@post = Post.find(params[:id])
	end

	def modify
		@post = Post.find(params[:id])
		@post.title = params[:title]
		@post.body = params[:body]		
		@post.save
		redirect_to posts_path
	end

	def delete
		@post = Post.find(params[:id])
		@post.destroy
		redirect_to posts_path
	end
end
