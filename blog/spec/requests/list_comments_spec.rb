require 'spec_helper'

#-------------------------------------------------------------------------------#

describe "AffichageListeComments" do
	before(:each) do
		@post = Post.create(:title => "Post11", :body => "bla bla")
		@comment1 = Comment.create(:author => "Alex", :body => "comment1", :id => 1, :post_id => @post.id)
		@comment2 = Comment.create(:author => "Boby", :body => "comment2", :id => 2, :post_id => @post.id)
		visit show_path(:id => @post.id)
	end

	describe "GET /posts/:id" do
		it "generates a listing of post's comments " do
    	current_path.should == "/posts/#{@post.id}"
			page.body.should include(@post.title)
			page.body.should include(@post.body)
			page.body.should include(@comment1.author)
			page.body.should include(@comment1.body)
			page.body.should include(@comment2.author)
			page.body.should include(@comment2.body)
		end

		it "is a button to add new comment" do
  		page.has_xpath?('//input[@id="Ajouter un commentaire"]')
			click_on('Ajouter un commentaire')
			current_path.should == "/posts/#{@post.id}/comments/new" 
		end
	end
end

#-------------------------------------------------------------------------------#

describe "CreationDeComment" do
	before (:each) do
		@post = Post.create(:title => "Post11", :body => "bla bla")
		visit new_post_comment_path(:id => @post.id)
	end	

	describe "GET /posts/:id/comments/new" do
		it "verifyCurrentPath" do
			current_path.should == "/posts/#{@post.id}/comments/new"
		end	

		it "verifyButtonValiderNewComment" do
			click_on('Create Comment')
		end

		it "verifyPresenceFormulaireAvecAuthorEtBody" do
			current_path.should == "/posts/#{@post.id}/comments/new"
			page.should have_selector('form')
			page.should have_field('comment_author')
			page.should have_field('comment_body')
			page.should have_button('Create Comment')
		end
	end

  describe "POST /posts/:id/comments" do
  	it "After Click go on posts/new" do
  	  fill_in('comment_author', :with => 'Zizou')
      fill_in('comment_body', :with => 'VS Materazzi')
      click_button('Create Comment')
      current_path.should == "/posts/#{@post.id}/comments/1"
    end
  end
end

#-------------------------------------------------------------------------------#

describe "SuppressionDeComment" do
  before (:each) do
		@post = Post.create(:title => "Post11", :body => "bla bla")
		@comment1 = Comment.create(:author => "Alex", :body => "comment1", :id => 1, :post_id => @post.id)
		@comment2 = Comment.create(:author => "Boby", :body => "comment2", :id => 2, :post_id => @post.id)
		visit show_path(:id => @post.id)
  end
  
	describe "DELETE /posts/:id/comments/:comment_id" do
	  it "verifyCurrentPath" do
    	current_path.should == "/posts/#{@post.id}"
    end   

    it "generates a listing of comments" do
	    page.body.should include(@post.title)
			page.body.should include(@post.body)
			page.body.should include(@comment1.author)
			page.body.should include(@comment1.body)
			page.body.should include(@comment2.author)
			page.body.should include(@comment2.body)
    end

		it "verifyLinkDeleteComment" do
    	page.should have_link("delete_comment#{@comment2.id}")
  	end

		it "verifyafterclickDelete" do
    	click_link("delete_comment#{@comment2.id}")
	    current_path.should == "/posts/#{@post.id}"
	    page.body.should include(@post.title)
			page.body.should include(@post.body)
      page.body.should include(@comment1.author)
			page.body.should include(@comment1.body)
      page.body.should_not include(@comment2.author)
      page.body.should_not include(@comment2.body)
    end   
  end
end 

#-------------------------------------------------------------------------------#

describe "ConsultationDeComment" do
  before (:each) do
		@post = Post.create(:title => "Post11", :body => "bla bla")
		@comment1 = Comment.create(:author => "Alex", :body => "comment1", :id => 1, :post_id => @post.id)
		@comment2 = Comment.create(:author => "Boby", :body => "comment2", :id => 2, :post_id => @post.id)
		visit show_path(:id => @post.id)
  end

  describe "GET /posts/:id" do
    it "verifyCurrentPath" do
    	current_path.should == "/posts/#{@post.id}"
  	end   
  
  	it "generates a listing of comments" do
	  	page.body.should include(@post.title)
    	page.body.should include(@post.body)
			page.body.should include(@comment1.author)
			page.body.should include(@comment1.body)
			page.body.should include(@comment2.author)
			page.body.should include(@comment2.body)
  	end

  	it "verifyLinkShowComment" do
    	page.should have_link("comment#{@comment1.id}")
  	end

  	it "verifyAfterClickShow" do
    	click_link("comment#{@comment1.id}")
    	current_path.should == "/posts/#{@post.id}/comments/#{@comment1.id}"
			page.body.should include(@comment1.author)
			page.body.should include(@comment1.body)
    	page.body.should_not include(@comment2.author)
    	page.body.should_not include(@comment2.body)
			page.should have_button('Retour')
			click_button('Retour')
			current_path.should == "/posts/#{@post.id}"                      
  	end   
  end
end

#-------------------------------------------------------------------------------#

describe "ModificationDeComment_First_Posibility" do
	before (:each) do
		@post = Post.create(:title => "Post11", :body => "bla bla")
		@comment1 = Comment.create(:author => "Alex", :body => "comment non modifie", :id => 1, :post_id => @post.id)
		visit show_path(:id => @post.id)
	end	

	describe "POST /posts/modify/:id/comments/:comment_id/edit" do
    it "verifyCurrentPath" do
    	current_path.should == "/posts/#{@post.id}"
  	end	

		it "verifyLinkModifyComment" do
    	page.should have_link("modify_comment#{@comment1.id}")
  	end

		it "verifyafterclickModify" do
    	click_link("modify_comment#{@comment1.id}")
      current_path.should == "/posts/#{@post.id}/comments/#{@comment1.id}/edit"
      page.body.should include(@comment1.author)
      page.body.should include(@comment1.body)
      fill_in('body', :with => 'Commentaire modifie')
      click_button("Valider")                                
			current_path.should == "/posts/#{@post.id}/comments/#{@comment1.id}"
			page.should have_selector('form')
			page.should have_field('author')
			page.should have_field('body')
			page.should have_button('Modifier')
			page.should have_button('Retour')
			page.should have_content("Commentaire modifie")
    	page.should_not have_content("comment non modifie")
			click_button('Retour')
			current_path.should == "/posts/#{@post.id}"
		end
  end
end

#-------------------------------------------------------------------------------#

describe "ModificationDeComment_Second_Posibility" do
	before (:each) do
		@post = Post.create(:title => "Post11", :body => "bla bla")
		@comment1 = Comment.create(:author => "Alex", :body => "comment non modifie", :id => 1, :post_id => @post.id)
		visit post_comment_path(:id => @post.id, :comment_id => @comment1.id)
	end	

	describe "POST /posts/modify/:id/comments/:comment_id/edit" do
    it "verifyCurrentPath" do
    	current_path.should == "/posts/#{@post.id}/comments/#{@comment1.id}"
  	end	

		it "verifyButtonModifyComment" do
    	page.should have_button("Modifier")
  	end

		it "verifyafterclickModify" do
    	click_button("Modifier")
      current_path.should == "/posts/#{@post.id}/comments/#{@comment1.id}/edit"
      page.body.should include(@comment1.author)
      page.body.should include(@comment1.body)
      fill_in('body', :with => 'Commentaire modifie')
      click_button("Valider")                                
			current_path.should == "/posts/#{@post.id}/comments/#{@comment1.id}"
			page.should have_selector('form')
			page.should have_field('author')
			page.should have_field('body')
			page.should have_button('Modifier')
			page.should have_button('Retour')
			page.should have_content("Commentaire modifie")
    	page.should_not have_content("comment non modifie")
			click_button('Retour')
			current_path.should == "/posts/#{@post.id}"
		end
  end
end

#-------------------------------------------------------------------------------#
