require 'spec_helper'

#-------------------------------------------------------------------------------#

describe "AffichageListeComments" do
	before(:each) do
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")	
		@post = Post.create(:person_id => @person.id, :title => "sujet1", :body => "bla bla")
		@comment1 = Comment.create(:author => "Alex", :body => "comment1", :id => 1, :post_id => @post.id)
		@comment2 = Comment.create(:author => "Boby", :body => "comment2", :id => 2, :post_id => @post.id)
		visit posts_path
		visit login_person_path
		fill_in('login', :with => @person.login)
		fill_in('password', :with => @person.password)
		click_button ('Login')
	end

	describe "GET /posts/:id" do
		it "goes on the post to see the comment list " do
    	current_path.should == posts_path
			page.should have_link("show_post#{@post.id}")
    	click_link("show_post#{@post.id}")
    	current_path.should == show_path(@post.id)
		end

		it "generates a listing of post's comments " do
			visit show_path(@post.id)
    	current_path.should == show_path(@post.id)
			page.body.should include(@post.title)
			page.body.should include(@post.body)
			page.body.should include(@comment1.author)
			page.body.should include(@comment1.body)
			page.body.should include(@comment2.author)
			page.body.should include(@comment2.body)
		end

		it "is a button to add new comment" do
			visit show_path(@post.id)
			click_on('Add a new comment')
			current_path.should == new_post_comment_path(@post.id)
		end
	end
end

#-------------------------------------------------------------------------------#

describe "CreationDeComment" do
	before (:each) do
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")	
		@post = Post.create(:person_id => @person.id, :title => "sujet1", :body => "bla bla")
		@comment1 = Comment.create(:author => "Alex", :body => "comment1", :id => 1, :post_id => @post.id, :person_id => @person.id)
		@comment2 = Comment.create(:author => "Boby", :body => "comment2", :id => 2, :post_id => @post.id, :person_id => @person.id)
		visit posts_path
		visit login_person_path
		fill_in('login', :with => @person.login)
		fill_in('password', :with => @person.password)
		click_button ('Login')
	end	

	describe "Autorization control" do
		it "verify if the person is logged" do
			current_path.should == posts_path
			page.should have_content ("Welcome #{@person.firstname}")
		end
	end
	
	describe "GET /posts/:id/comments/new" do
		it "verifyCurrentPath" do
			visit show_path(@post.id)
			page.should have_button ("Add a new comment")
			click_on('Add a new comment')	
			current_path.should == new_post_comment_path(@post.id)
		end	

		it "verifyPresenceFormulaireAvecAuthorEtBody" do
			visit new_post_comment_path(@post.id)
			page.should have_selector('form')
			page.should have_field('comment_author')
			page.should have_field('comment_body')
			page.should have_button('Create')
			page.should have_button('Back')
		end
	end

  describe "POST /posts/:id/comments" do
  	it "After Click go on posts/new" do
			visit new_post_comment_path(@post.id)
  	  fill_in('comment_author', :with => @person.login)
      fill_in('comment_body', :with => 'creation de commentaire')
      click_button('Create')
			visit show_path(@post.id)
    end
  end
end

#-------------------------------------------------------------------------------#

describe "SuppressionDeComment" do
  before (:each) do
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")	
		@post1 = Post.create(:person_id => @person.id, :title => "sujet1", :body => "bla bla")
		@post2 = Post.create(:person_id => @person.id, :title => "sujet1", :body => "bla bla")
		@comment1 = Comment.create(:author => "Alex", :body => "comment1", :id => 1, :post_id => @post1.id, :person_id => @person.id)
		@comment2 = Comment.create(:author => "Jojo", :body => "comment2", :id => 1, :post_id => @post1.id, :person_id => @person.id)
		@comment3 = Comment.create(:author => "Boby", :body => "comment3", :id => 2, :post_id => @post2.id, :person_id => @person.id)
		@comment4 = Comment.create(:author => "Freud", :body => "comment4", :id => 1, :post_id => @post2.id, :person_id => @person.id)
		@comments = [@comment1, @comment2, @comment3,@comment4]
		visit posts_path
		visit login_person_path
		fill_in('login', :with => @person.login)
		fill_in('password', :with => @person.password)
		click_button ('Login')
		visit show_path(@post1.id)		
  end
  
	describe "DELETE /posts/:id/comments/:comment_id" do
	  it "verifyCurrentPath" do
    	current_path.should == show_path(@post1.id)
    end   

 		it "generates a listing of comments for each post dedicated" do
			@comments.each do |com| 		
				if com.post_id == @post1.id				
					page.body.should include(com.author)
					page.body.should include(com.body)					
				end			
			end
			page.body.should_not include(@comment3.author)
			page.body.should_not include(@comment3.body)
			page.body.should_not include(@comment4.author)
			page.body.should_not include(@comment4.body)					
		end	

		it "verifyLinkDeleteComment" do
			@comments.each do |c| 
				if c.post_id == @post1.id				
					page.should have_button("delete_comment#{c.id}")
				end
				page.should_not have_button("delete_comment#{@comment3.id}")
				page.should_not have_button("delete_comment#{@comment4.id}")
			end    	
		end

		it "verifyafterclickDelete" do
    	click_button("delete_comment#{@comment1.id}")
	    current_path.should == show_path(@post1.id)
	    page.should have_button("delete_comment#{@comment2.id}")
			page.body.should include(@comment2.author)
			page.body.should include(@comment2.body)			
			page.should_not have_button("delete_comment#{@comment1.id}")
			page.body.should_not include(@comment1.author)
			page.body.should_not include(@comment1.body)
			page.should_not have_button("delete_comment#{@comment3.id}")
			page.body.should_not include(@comment3.author)
			page.body.should_not include(@comment3.body)						
			page.should_not have_button("delete_comment#{@comment4.id}")
			page.body.should_not include(@comment4.author)
			page.body.should_not include(@comment4.body)
			page.should have_content("Comment was successfully destroyed.")					
    end   
  end
end 

#-------------------------------------------------------------------------------#

describe "ConsultationDeComment" do
  before (:each) do
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")	
		@post1 = Post.create(:person_id => @person.id, :title => "sujet1", :body => "bla bla")
		@post2 = Post.create(:person_id => @person.id, :title => "sujet1", :body => "bla bla")
		@comment1 = Comment.create(:author => "Alex", :body => "comment1", :id => 1, :post_id => @post1.id, :person_id => @person.id)
		@comment2 = Comment.create(:author => "Jojo", :body => "comment2", :id => 1, :post_id => @post1.id, :person_id => @person.id)
		@comment3 = Comment.create(:author => "Boby", :body => "comment3", :id => 2, :post_id => @post2.id, :person_id => @person.id)
		@comment4 = Comment.create(:author => "Freud", :body => "comment4", :id => 1, :post_id => @post2.id, :person_id => @person.id)
		@comments = [@comment1, @comment2, @comment3,@comment4]
		visit posts_path
		visit login_person_path
		fill_in('login', :with => @person.login)
		fill_in('password', :with => @person.password)
		click_button ('Login')
		visit show_path(@post1.id)
  end

  describe "GET /posts/:id" do
    it "verifyCurrentPath" do
    	current_path.should == show_path(@post1.id)
    end   
  
  	it "generates a listing of comments for each post dedicated" do
			@comments.each do |com| 		
				if com.post_id == @post1.id				
					page.body.should include(com.author)
					page.body.should include(com.body)					
				end			
			end
			page.body.should_not include(@comment3.author)
			page.body.should_not include(@comment3.body)
			page.body.should_not include(@comment4.author)
			page.body.should_not include(@comment4.body)					
		end

  	it "verifyLinkShowComment" do
			@comments.each do |com| 		
				if com.post_id == @post1.id				
    			page.should have_button("comment#{com.id}")					
				end			
			end
    	page.should_not have_button("comment#{@comment3.id}")
    	page.should_not have_button("comment#{@comment4.id}")
  	end

  	it "verifyAfterClickShow" do
    	click_button("comment#{@comment1.id}")
    	current_path.should == post_comment_path(@post1.id, @comment1.id)
			page.body.should include(@comment1.author)
			page.body.should include(@comment1.body)
    	page.body.should_not include(@comment2.author)
    	page.body.should_not include(@comment2.body)
			page.should have_button('Back')
			click_button('Back')
			current_path.should == show_path(@post1.id)                      
  	end   
  end
end

#-------------------------------------------------------------------------------#

describe "ModificationDeComment_First_Posibility : depuis la page avec la liste des commentaires" do
	before (:each) do
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")	
		@post1 = Post.create(:person_id => @person.id, :title => "sujet1", :body => "bla bla")
		@post2 = Post.create(:person_id => @person.id, :title => "sujet1", :body => "bla bla")
		@comment1 = Comment.create(:author => "Alex", :body => "comment1", :id => 1, :post_id => @post1.id, :person_id => @person.id)
		@comment2 = Comment.create(:author => "Jojo", :body => "comment2", :id => 1, :post_id => @post1.id, :person_id => @person.id)
		@comment3 = Comment.create(:author => "Boby", :body => "comment3", :id => 2, :post_id => @post2.id, :person_id => @person.id)
		@comment4 = Comment.create(:author => "Freud", :body => "comment4", :id => 1, :post_id => @post2.id, :person_id => @person.id)
		@comments = [@comment1, @comment2, @comment3,@comment4]
		visit posts_path
		visit login_person_path
		fill_in('login', :with => @person.login)
		fill_in('password', :with => @person.password)
		click_button ('Login')
		visit show_path(@post1.id)
	end	

	describe "POST /posts/:id/comments/:comment_id/edit" do
    it "verifyCurrentPath" do
    	current_path.should == show_path(@post1.id)
  	end	

		it "verifyLinkModifyComment" do
    	page.should have_button("modify_comment#{@comment1.id}")
  	end

		it "verifyafterclickModify" do
    	click_button("modify_comment#{@comment1.id}")
      current_path.should == edit_post_comment_path(@post1.id, @comment1.id)
      page.body.should include(@comment1.author)
      page.body.should include(@comment1.body)
      fill_in('body', :with => 'Commentaire modifie')
      click_button("Modify")                                
			current_path.should == post_comment_path(@post1.id, @comment1.id)
			page.should have_selector('form')
			page.should have_field('author')
			page.should have_field('body')
			page.should have_button('Edit')
			page.should have_button('Back')
			page.should have_content("Commentaire modifie")
    	page.should_not have_content("comment1")
			click_button('Back')
			current_path.should == show_path(@post1.id)
		end
  end
end

#-------------------------------------------------------------------------------#

describe "ModificationDeComment_Second_Posibility : depuis la page avec de visualisation d un commentaire" do
	before (:each) do
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")	
		@post1 = Post.create(:person_id => @person.id, :title => "sujet1", :body => "bla bla")
		@post2 = Post.create(:person_id => @person.id, :title => "sujet1", :body => "bla bla")
		@comment1 = Comment.create(:author => "Alex", :body => "comment1", :id => 1, :post_id => @post1.id, :person_id => @person.id)
		@comment2 = Comment.create(:author => "Jojo", :body => "comment2", :id => 1, :post_id => @post1.id, :person_id => @person.id)
		@comment3 = Comment.create(:author => "Boby", :body => "comment3", :id => 2, :post_id => @post2.id, :person_id => @person.id)
		@comment4 = Comment.create(:author => "Freud", :body => "comment4", :id => 1, :post_id => @post2.id, :person_id => @person.id)
		@comments = [@comment1, @comment2, @comment3,@comment4]
		visit posts_path
		visit login_person_path
		fill_in('login', :with => @person.login)
		fill_in('password', :with => @person.password)
		click_button ('Login')
		visit post_comment_path(:id => @post1.id, :comment_id => @comment1.id)
	end	

	describe "POST /posts/:id/comments/:comment_id/edit" do
    it "verifyCurrentPath" do
    	current_path.should == post_comment_path(:id => @post1.id, :comment_id => @comment1.id)
  	end	

		it "verifyButtonModifyComment" do
    	page.should have_button("Edit")
    	page.should have_button("Back")
  	end

		it "verifyafterclickModify" do
    	click_button("Edit")
      current_path.should == edit_post_comment_path(@post1.id, @comment1.id)
      page.body.should include(@comment1.author)
      page.body.should include(@comment1.body)
      fill_in('body', :with => 'Commentaire modifie')
      click_button("Modify")                                
			current_path.should == post_comment_path(@post1.id, @comment1.id)
			page.should have_selector('form')
			page.should have_field('author')
			page.should have_field('body')
			page.should have_button('Edit')
			page.should have_button('Back')
			page.should have_content("Commentaire modifie")
    	page.should_not have_content("comment1")
			click_button('Back')
			current_path.should == show_path(@post1.id)
		end
  end
end

#-------------------------------------------------------------------------------#
