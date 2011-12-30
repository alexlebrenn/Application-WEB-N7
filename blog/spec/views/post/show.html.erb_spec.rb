require 'spec_helper'

#------------------------------The User is not logged----------------------------------------#

describe "post/show.html.erb" do
  before(:each) do
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")
		@post = stub_model(Post, :person_id => @person, :title => "post1", :body => "body post1")
		assign(:post, @post)
		@comment1 = stub_model(Comment, :author => "jojo", :body => "comment1", :post_id =>@post.id)
		@comment2 = stub_model(Comment, :author => "mike", :body => "comment2", :post_id =>@post.id)
		@comments = [@comment1, @comment2]					
		assign(:comments, [@comment1, @comment2])
		controller.request.path_parameters[:id] = @post.id
		render
	end	

	it "displays 2 textfields and a textarea" do
		rendered.should have_content('Author :')
		rendered.should =~ /#{@post.person_id}/
		rendered.should have_content('Title :')
		rendered.should =~ /#{@post.title}/
		rendered.should have_content('Body :')
		rendered.should =~ /#{@post.body}/						
		rendered.should have_selector("input",:type => "text", :name => "author_post", :content => @post.person_id)
		rendered.should have_selector("input",:type => "text", :name => "title", :content => @post.title)
  	rendered.should have_selector("textarea", :name => "body", :content => @post.body) 
	end

    
  it "should have a button to add a comment to a post" do
		rendered.should have_selector("input", :type => "submit", :name => "Add a new comment", :href => new_post_comment_path(@post.id)) 
		rendered.should have_button("Add a new comment")
	end
	
	it "should have a button to go to the Home Page" do
		rendered.should have_selector("input", :type => "submit", :name => "Home Page", :href => posts_path) 
		rendered.should have_button("Home Page")
	end 

	it "should not have a button Edit for all comments posted because no user logged" do
		@comments.each do |c| 			
			rendered.should have_selector("input", :type => "submit", :href => edit_post_comment_path(c.post_id, c.id))	
			rendered.should_not have_button("Edit")						
		end 
	end

	it "should not have a button Delete for all comments posted" do
		@comments.each do |c| 			
			rendered.should have_selector("input", :type => "submit", :href => delete_post_comment_path(c.post_id, c.id))
			rendered.should_not have_button("Delete")			
		end 
	end	
end

#------------------------------The User is logged----------------------------------------#

describe "post/show.html.erb" do
  before(:each) do
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")
		@post = stub_model(Post, :person_id => @person, :title => "post1", :body => "body post1")
		assign(:post, @post)
		@comment1 = stub_model(Comment, :author => "jojo", :body => "comment1", :post_id =>@post.id, :person_id => @person.id)
		@comment2 = stub_model(Comment, :author => "mike", :body => "comment2", :post_id =>@post.id, :person_id => @person.id)
		@comments = [@comment1, @comment2]					
		assign(:comments, [@comment1, @comment2])
		controller.request.path_parameters[:id] = @post.id
		session[:id] = @person.id
		session[:firstname] = @person.firstname	
		session[:name] = @person.name	
		session[:login] = @person.login	
		session[:password] = @person.password	
		render
	end	

	it "displays 2 textfields and a textarea" do
		rendered.should have_content('Author :')
		rendered.should =~ /#{@post.person_id}/
		rendered.should have_content('Title :')
		rendered.should =~ /#{@post.title}/
		rendered.should have_content('Body :')
		rendered.should =~ /#{@post.body}/						
		rendered.should have_selector("input",:type => "text", :name => "author_post", :content => @post.person_id)
		rendered.should have_selector("input",:type => "text", :name => "title", :content => @post.title)
  	rendered.should have_selector("textarea", :name => "body", :content => @post.body) 
	end

    
  it "should have a button to add a comment to a post" do
		rendered.should have_selector("input", :type => "submit", :name => "Add a new comment", :href => new_post_comment_path(@post.id)) 
		rendered.should have_button("Add a new comment")
	end
	
	it "should have a button to go to the Home Page" do
		rendered.should have_selector("input", :type => "submit", :name => "Home Page", :href => posts_path) 
		rendered.should have_button("Home Page")
	end 

	it "should have a button Edit for each comment if you are the owner of this comment" do
		@comments.each do |c|
			if c.person_id = session[:id]			
				rendered.should have_selector("input", :type => "submit", :href => edit_post_comment_path(c.post_id, c.id))	
				#rendered.should have_button("modify_comment#{c.id}")
			end
		end 
	end

	it "should have a button Delete for all comments posted if you are the o wner of the post" do
		@comments.each do |c|
			if @post.person_id = session[:id]				
				rendered.should have_selector("input", :type => "submit", :href => delete_post_comment_path(c.post_id, c.id))
				#rendered.should have_button("delete_comment#{c.id}")
			end			
		end 
	end	
end


