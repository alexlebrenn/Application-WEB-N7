class CommentsController < ApplicationController

	before_filter :authenticate, :except => [:index, :show, :new, :create]

  def index
    post = Post.find(params[:id])
    #Get all the comments of this post
    @comments = post.comments
    
		respond_to do |format|
      format.html
      format.json  { render :json => @comments }
    end
  end


  # GET /posts/:id/comments/:comment_id
  def show
    @post = Post.find(params[:id])
    @comment = @post.comments.find(params[:comment_id])
    
		respond_to do |format|
      format.html
      format.json  { render :json => @comment }
    end
  end


  # GET /posts/:id/comments/new
  def new
    post = Post.find(params[:id])
    @comment = post.comments.build
    
		respond_to do |format|
      format.html
      format.json  { render :json => @comment }
    end
  end


  # POST /posts/:id/comments
  def create
    post = Post.find(params[:id])
    @comment = post.comments.create(params[:comment])
		@comment.person_id = session[:id]
	  
		if @comment.save
      respond_to do |format|
        flash[:notice] = "Comment created with success."
        format.html { redirect_to(post_comment_path(@comment.post_id, @comment.id)) }
      end
    else
      respond_to do |format|
        flash[:error] = "Comment can\'t be created."
        format.html { render :action => "new" }
      end
    end
  end


  # GET /posts/:id/comments/:comment_id/edit
  def edit
    post = Post.find(params[:id])
    @comment = post.comments.find(params[:comment_id])
  end


  # PUT /posts/:id/comments/:id
  def update
    post = Post.find(params[:id])
    @comment = post.comments.find(params[:comment_id])
		@comment.author = params[:author]	
		@comment.body = params[:body]
		@comment.person_id = session[:id]

		if @comment.save
      respond_to do |format|
        flash[:notice] = "Comment was successfully updated."
        format.html { redirect_to(post_comment_path(@comment.post_id, @comment.id)) }
      end
    else
      respond_to do |format|
        flash[:error] = "Comment can\'t be created."
        format.html { render :action => "edit" }
      end
    end
  end


  # DELETE /posts/:id/comments/1
  def delete
    @post = Post.find(params[:id])
    @comment = @post.comments.find(params[:comment_id])

		if Comment.destroy(params[:comment_id])
      flash[:notice] = "Comment was successfully destroyed."
    else
      flash[:error] = "Comment can\'t be destroyed."
    end
    respond_to do |format|
			format.html {redirect_to show_path(params[:id])}
		end
  end

end
