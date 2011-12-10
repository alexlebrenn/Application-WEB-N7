require 'spec_helper'

describe PostController do

#---------------------------------------------------------------------------------------#

	describe "GET 'index'" do
		before(:each) do
			@posts = [stub_model(Post,:title => "1"), stub_model(Post, :title => "2")]
			Post.stub(:all){ @posts }
		end

		it "should get all the posts from the database and assigns the list of posts to @posts" do
			Post.should_receive(:all).and_return(@posts)
			get 'index'
			assigns(:posts).should eq @posts
			response.should be_success
		end

		it "renders the template list" do
			get 'index'
			response.should render_template(:index)
		end
	end

#---------------------------------------------------------------------------------------#

  describe "POST 'create'" do
    it "should redirect to the todo list" do
      post :create
      response.should redirect_to posts_path
    end
  end

#	describe "POST 'create'" do
#		before(:each) do
#			@post = stub_model(Post)
#    	@new_post_params = {"post" => {"title" => "post_title", "body" => "post_body"}}
#    	Post.stub(:new) {@post}

#			@post = [stub_model(Post,:title => "1", :body => "2")]

		  #@new_post_params = {"post" => {"title" => "post_title", "body" => "post_body"}}
		  #Post.stub(:new) {@post}


#    end
    #post = Post.new("title" => …, "body" => …)
#    it "should create a new Post with the given params" do
#      Post.should_receive(:new).with(@new_post_params)
#      post :create, @new_post_params
#    end

#    it "should redirect to posts_path" do
#      post :create, @new_post_params
#      response.should redirect_to posts_path
#    end
#  end

#---------------------------------------------------------------------------------------#

	describe "DELETE 'delete'" do
    before(:each) do
      @post = stub_model(Post, :id => 1)
      @post.stub(:destroy){ true }
      Post.stub(:find){@post}
    end

    it "should search the post" do
      Post.should_receive(:find).with(@post.id.to_s).and_return(@post)
      delete :delete, {:id => @post.id }
    end

    it "should destroy the post" do
      @post.should_receive(:destroy)
      delete :delete, {:id => @post.id }
    end

    it "should redirect to the posts list" do
      delete :delete, {:id => @post.id }
      response.should redirect_to posts_path
    end
	end

#---------------------------------------------------------------------------------------#

	describe "GET 'show'" do
    before(:each) do
      @post = stub_model(Post, :id => 1)
      Post.stub(:find){@post}
    end

    it "should search the post" do
      Post.should_receive(:find).with(@post.id.to_s).and_return(@post)
      get :show, {:id => @post.id }
    end
	end

#---------------------------------------------------------------------------------------#       
end

