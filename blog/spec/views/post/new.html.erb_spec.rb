require 'spec_helper'

describe "post/new.html.erb" do
	before(:each) do	
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")
		@post = stub_model(Post, :person_id => @person, :title => "post1", :body => "body1")
		render
	end	
	
  it "displays the title of the page " do
		rendered.should have_content("Creating a new Post")
	end
  
	it "displays 2 textfielda nd a textarea" do
		rendered.should have_selector("input",:type => "text", :name => "author_post")
		rendered.should have_selector("input",:type => "text", :name => "title")
  	rendered.should have_selector("textarea", :name => "body") 
	end
	
	it "should have a button named Create" do
	   	rendered.should have_selector("input", :type => "submit", :name => "Create", :href => posts_path)  
 	   	rendered.should have_button("Create")	   		   	
	end

	it "should have a button named Home Page" do
	   	rendered.should have_selector("input", :type => "submit", :name => "Home Page", :href => posts_path)  
 	   	rendered.should have_button("Home Page")	   		   	
	end
	
end
