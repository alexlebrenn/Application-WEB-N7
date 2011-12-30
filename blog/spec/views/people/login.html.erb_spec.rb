require 'spec_helper'

describe "people/login.html.erb" do
  before(:each) do
		@post = Post.create(:title => "Post11", :body => "bla bla")
		@comment = Comment.create(:author => "Alex", :body => "comment1", :id => 1, :post_id => @post.id)
		render
  end

  it "displays 2 textfields" do
		rendered.should have_content('Login :')
		rendered.should have_content('Password :')
   	rendered.should have_selector("input", :type => "text")    
   	rendered.should have_selector("input", :type => "password")    
	end

	it "should have a button to Log in" do
		rendered.should have_selector("input", :type => "submit", :name => "Login", :href => login_person_path) 
		rendered.should have_button("Login")
	end

	it "should have a button to back to the Home Page" do
		rendered.should have_selector("input", :type => "submit", :name => "Home Page", :href => posts_path) 
		rendered.should have_button("Home Page")
	end	
end

