require 'spec_helper'

describe "comments/show.html.erb" do
  before(:each) do
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")
		@post = Post.create(:person_id => @person.id, :title => "post1", :body => "body1")
		@comment = Comment.create(:author => "alex", :body => "comment1", :post_id =>@post.id)	
		render
  end

	it "displays a textfield and a textarea" do
		rendered.should have_content('Author :')
		rendered.should have_content('Body :')
   	rendered.should have_selector("input", :type => "text")    
   	rendered.should have_selector("textarea") 
	end  

  it "displays a button to modify the comment" do
   	rendered.should have_selector("form",:method => "GET")
   	rendered.should have_selector("input", :type => "submit", :name => "Modify", :href => edit_post_comment_path(@post.id, @comment.id))   	
  end
    
  it "should have a button to back to the previous page" do
		rendered.should have_selector("input", :type => "submit", :name => "back", :href => show_path(@post.id)) 
		rendered.should have_button("Back")
	end	
end
