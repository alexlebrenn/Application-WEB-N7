require 'spec_helper'

describe CommentsController do

#---------------------------------------------------------------------------------------#  

	describe "GET 'indexcomment'" do
		before(:each) do
 			@post = (stub_model(Post, :title => "Titre", :body=>"Contenu"))
    	@comments = [stub_model(Comment, :author => "Alex", :body=>"Commentaire1", :post_id => @post),
									 stub_model(Comment, :author => "Boby", :body=>"Commentaire2", :post_id => @post)]
			Comment.stub(:all){ @comments }
   end

		it "should get all the comments of a post from the database and assigns the list of comments to @comments" do
			#Comment.should_receive(:all).and_return(@comments)
			#get :show, :post => { :id => @post.id}
			#assigns(:comments).should eq @comments
			#response.should be_success
		end

		it "renders the template list" do
			#get :show, :post => { :id => @post.id}
			#response.should render_template(:indexcomment)
		end
	end

#---------------------------------------------------------------------------------------#

  describe "POST 'create'" do
		before(:each) do
	    @post = (stub_model(Post, :title => "Titre", :body=>"Contenu"))
    	@comment = (stub_model(Comment, :author => "Alex", :body=>"Commentaire", :post_id => @post))
   end

   it "should generate post_comments_path" do
     controller.post_comment_path(@post,@comment).should == "/posts/#{@post.id}/comments/#{@comment.id}"
   end

   it "should assign the new comment to @comment" do
     assigns[:comment].should == Comment.find_by_author_and_body_and_post_id("Alex", "Commentaire", @post.id)
   end
	end

#---------------------------------------------------------------------------------------#

	describe "DELETE 'destroy'" do
    before(:each) do
	    @post = (stub_model(Post, :id => 22))
      Post.stub(:find){@post}
    	@comment = (stub_model(Comment, :id => 11, :post_id => @post))
      @comment.stub(:destroy){ true }
      Comment.stub(:find){@comment}
    end

    it "destroys the requested comment" do
      Comment.should_receive(:find).with(@post.id.to_s, @comment.id.to_s).and_return(@comment)
      @comment.should_receive(:destroy)
      delete :delete, {:id => @post.id , :comment_id => @comment.id}
		end

    it "should redirect to the comments list" do
      delete :delete, {:id => @comment.id , :comment_id => @comment.id}
      response.should redirect_to show_path
    end
	end
#---------------------------------------------------------------------------------------#

end
