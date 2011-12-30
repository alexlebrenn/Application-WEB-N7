require 'spec_helper'

describe "post/receive.html.erb" do
	before(:each) do
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")
		@post = stub_model(Post, :person_id => @person, :title => "post1", :body => "body1")
		render
	end

  it "displays the title of the page " do
		rendered.should have_content("Modification of Post")
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

	it "should have a button named 'Modify'" do
		rendered.should have_selector("input", :type => "submit", :name => "Modify", :href => show_path(@post.id)) 
		rendered.should have_button("Modify")
	end    	
end
