require 'spec_helper'

describe "comments/edit.html.erb" do
	before(:each) do	
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")
		@post = Post.create(:person_id => @person.id, :title => "post1", :body => "body1")
		@comment = Comment.create(:author => "alex", :body => "comment1", :post_id =>@post.id)		
		render
	end

  it "displays the title of the page " do
		rendered.should have_content("Modification of Comment")
	end

	it "displays 2 textfields and a textarea" do
		rendered.should have_content('Author :')
		rendered.should =~ /#{@comment.person_id}/
		rendered.should have_content('Body :')
		rendered.should =~ /#{@comment.body}/						
		rendered.should have_selector("input",:type => "text", :name => "author", :content => @comment.person_id)
  	rendered.should have_selector("textarea", :name => "body", :content => @comment.body) 
	end

	it "should have a button named 'Modify'" do
		rendered.should have_selector("input", :type => "submit", :name => "Modify", :href => post_comment_path(@post.id, @comment.id)) 
		rendered.should have_button("Modify")
	end    
end
