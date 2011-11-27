class CommentsController < ApplicationController

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
    post = Post.find(params[:id])
    @comment = post.comments.find(params[:comment_id])
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

  # GET /posts/:id/comments/:comment_id/edit
  def edit
    post = Post.find(params[:id])
    @comment = post.comments.find(params[:comment_id])
  end

  # POST /posts/:id/comments
  def create
    post = Post.find(params[:id])
    @comment = post.comments.create(params[:comment])
		@comment.save
    respond_to do |format|
    	format.html { redirect_to([@comment.post, @comment], :notice => 'Comment was successfully created.') }
      format.json  { render :json => @comment, :status => :created, :location => [@comment.post, @comment] }
    end
	end

  # PUT /posts/:id/comments/:id
  def update
    post = Post.find(params[:id])
    @comment = post.comments.find(params[:comment_id])
		@comment.author = params[:author]	
		@comment.body = params[:body]
		@comment.save
    respond_to do |format|
	    format.html { redirect_to([@comment.post, @comment], :notice => 'Comment was successfully updated.') }
      format.json  { head :ok }
    end
  end

  # DELETE /posts/:id/comments/1
  def delete
    post = Post.find(params[:id])
    @comment = post.comments.find(params[:comment_id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to(show_path) }
      format.json  { head :ok }
    end
  end
end
