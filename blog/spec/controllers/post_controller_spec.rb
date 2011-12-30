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
			@person = Person.create(:firstname => "michel", :name => "jordan", :login => "mjordan", :password =>"jordan" )
			session[:id] = @person.id
      post :create
      response.should be_success
    end
  end

	describe "POST 'create'" do
		before(:each) do
			@person = Person.create(:firstname => "michel", :name => "jordan", :login => "mjordan", :password =>"jordan" )
			session[:id] = @person.id
			@new_post = {"post" => {"author" => "mjordan", "title" => "Post 1", "body" => "Contenu du post"}}
			@post = stub_model(Post)
			Post.stub(:new) {@post}
		end

	  it "should create a new post with its params" do
			Post.should_receive(:new)
			post :create, @new_post
      response.should be_success
		end
	end

#---------------------------------------------------------------------------------------#

	describe "DELETE 'delete'" do
    before(:each) do
			@person = Person.create(:firstname => "michel", :name => "jordan", :login => "mjordan", :password =>"jordan" )
			session[:id] = @person.id
      @post = stub_model(Post, :id => 1)
      Post.stub(:find){@post}      
			@post.stub(:destroy){ true }
    end

    it "should search the post" do
      Post.should_receive(:find).with(@post.id.to_s).and_return(@post)
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

	describe "PUT 'modify'" do
		before(:each) do
			@person = Person.create(:firstname => "michel", :name => "jordan", :login => "mjordan", :password =>"jordan" )
			session[:id] = @person.id
			@post1 = Post.create(:title => "Post 1", :body => "Contenu du post1")
			@post2 = Post.create(:title => "Post 2", :body => "Contenu du post2")
			@posts = [@post1, @post2]
			Post.stub(:all){ @posts }
			get 'index'
			Post.stub(:find) { @post1 }
		end

		it "modify the post" do
			Post.should_receive(:find).and_return(@postreturn)	
			assigns(@post1).should eq @postreturn			
			post "receive", {:id => @post1.id}	
			response.should be_success
			put :modify, {:id => @post1.id}
			response.should be_success
		end
	end

#---------------------------------------------------------------------------------------#   
    
end
