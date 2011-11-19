class CommentsController < ApplicationController

  def index
    post = Post.find(params[:id])
    #Get all the comments of this post
    @comments = post.comments
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @comments }
    end
  end

  # GET /posts/:id/comments/:comment_id
  def show
    post = Post.find(params[:id])
    @comment = post.comments.find(params[:comment_id])
    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @comment }
    end
  end

  # GET /posts/:id/comments/new
  def new
    post = Post.find(params[:id])
    #Build a new one
    @comment = post.comments.build
    respond_to do |format|
      format.html # new.html.erb
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
    #2nd you create the comment with arguments in params[:comment]
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
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        #1st argument of redirect_to is an array, in order to build the correct route to the nested resource comment
        format.html { redirect_to([@comment.post, @comment], :notice => 'Comment was successfully updated.') }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/:id/comments/1
  def delete
    post = Post.find(params[:id])
    #2nd you retrieve the comment thanks to params[:id]
    @comment = post.comments.find(params[:comment_id])
    @comment.destroy
    respond_to do |format|
      #1st argument reference the path /posts/:post_id/comments/
      format.html { redirect_to(show_path) }
      format.json  { head :ok }
    end
  end
end
