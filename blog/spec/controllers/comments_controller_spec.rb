require 'spec_helper'

describe CommentsController do

#---------------------------------------------------------------------------------------#

	describe "POST 'create'" do
		before(:each) do
  		@post = Post.create(:title => "Titre", :body => "Contenu", :id => 1 )
 			@comment = (stub_model(Comment, :author => "Alex", :body=>"Commentaire", :post_id => @post.id))
			Comment.stub(:new) {@comment}
		end

   	it "should generate post_comments_path" do
     	controller.post_comment_path(@post,@comment).should == "/posts/#{@post.id}/comments/#{@comment.id}"
   	end

   	it "should assign the new comment to @comment" do
     	assigns[:comment].should == Comment.find_by_author_and_body_and_post_id("Alex", "Commentaire", @post.id)
   	end

		it "should create a new Comment with its params" do
			Comment.should_receive(:new)
			post :create, {:id => @post.id}
		end

		it "should redirect to Comment's view" do
			post :create, {:id => @post.id}
			response.should redirect_to post_comment_path(@post.id, @comment.id)
		end		
	end

#---------------------------------------------------------------------------------------#

	describe "DELETE 'delete'" do
    before(:each) do
			@person = Person.create(:firstname => "michel", :name => "jordan", :login => "mjordan", :password =>"jordan" )
			session[:id] = @person.id
  		@post = Post.create(:title => "Titre", :body => "Contenu", :id => 1)
			@comment = Comment.create(:author => "mjordan", :body => "Commentaire", :post_id => @post.id, :id => "10" )										 			
			@comment.stub(:delete){ true }
			Post.stub(:find){ @post }			
			@post.comments.stub(:find){ @comment }	
    end

    it "destroys the requested comment" do
      Comment.should_receive(:destroy)
      delete :delete, {:id => @comment.post_id, :comment_id => @comment.id}
    end

    it "should redirect to the posts list" do
      delete :delete, {:id => @comment.post_id, :comment_id => @comment.id}
      response.should redirect_to show_path(@post.id)
    end
	end

#---------------------------------------------------------------------------------------#

	describe "GET 'show'" do
    before(:each) do
  		@post = Post.create(:title => "Titre", :body => "Contenu", :id => "1" )
			@comment = Comment.create(:author => "alex", :body => "corps du commentaire", :post_id => @post.id, :id => "1") 
			@comment.stub(:save){ true }
			Post.stub(:find){ @post }			
			@post.comments.stub(:find){ @comment }	
    end

    it "should search the comment" do
      get :show, {:id => @post.id, :comment_id => @comment.id}
			response.should be_success
    end
	end

#---------------------------------------------------------------------------------------#

	describe "GET 'edit'" do
		before(:each) do
  		@post = Post.create(:title => "Titre", :body => "Contenu", :id => 1 )
			@comment = Comment.create(:author => "alex", :body => "corps du commentaire", :post_id => @post.id, :id => "1")
			@comment.stub(:save){ true }
			Post.stub(:find){ @post }			
			@post.comments.stub(:find){ @comment }	
		end
	
		it "should find the post which will own the comment" do
			assigns(@post).should eq @post_return
			response.should be_success
		end
		
		it "should find the comment owned by @post" do
			@post.comments.stub(:find){ @comment.id }		
			get 'edit', {:id => @post.id, :comment_id => @comment.id}
		end
	end

#---------------------------------------------------------------------------------------#

	describe "PUT 'update'" do
		before(:each) do
			@person = Person.create(:firstname => "michel", :name => "jordan", :login => "mjordan", :password =>"jordan" )
			session[:id] = @person.id
  		@post = Post.create(:title => "Titre", :body => "Contenu", :id => 1 )
			@comment = Comment.create(:author => "alex", :body => "corps du commentaire", :post_id => @post.id, :id => "1") 
			@comment.stub(:save){ true }
			Post.stub(:find){ @post }			
			@post.comments.stub(:find){ @comment }								
		end
		
		it "should redirect to the @post view" do
			put :update, {:id => @comment.post_id, :comment_id => @comment.id}	
			response.should be_success
		end
		
		it "should modify the post" do
			put :update, {:id => @comment.post_id, :comment_id => @comment.id}	
		end		
	end

#---------------------------------------------------------------------------------------#
end
