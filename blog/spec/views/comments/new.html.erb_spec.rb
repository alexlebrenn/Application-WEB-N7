require 'spec_helper'

describe "comments/new.html.erb" do
	before(:each) do
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")
		@post = Post.create(:person_id => @person.id, :title => "post1", :body => "body1")
		@comment = Comment.create(:author => "alex", :body => "comment1", :post_id =>@post.id)	
		render
	end

	it "displays the title of the page " do
		rendered.should have_content("Creating a new Comment")
	end

	it "displays a textfield and a textarea" do
		rendered.should have_content('Author :')
		rendered.should have_content('Body :')
   	rendered.should have_selector("input", :type => "text")    
   	rendered.should have_selector("textarea") 
	end  

  it "displays a form to create a new comment" do
   	rendered.should have_selector("form",:method => "POST")
   	rendered.should have_selector("input", :type => "submit", :name => "Create", :href => post_comment_path(@post.id, @comment.id))   	
  end
    
  it "should have a button to back to the preivous page" do
		rendered.should have_selector("input", :type => "submit", :name => "back", :href => show_path(@post.id)) 
		rendered.should have_button("Back")
	end	
end
