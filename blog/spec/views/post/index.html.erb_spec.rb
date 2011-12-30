require 'spec_helper'

#------------------------------The User is not logged----------------------------------------#

describe "post/index.html.erb" do
	before(:each) do	
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")
		@person2 = Person.create(:login => "mjordan", :password => "michjojo", :name => "jordan", :firstname => "michel", :id => "2")		
		@post1 = stub_model(Post, :person_id => @person1, :title => "post1")
		@post2 = stub_model(Post, :person_id => @person2, :title => "post2")
		@post3 = stub_model(Post, :person_id => @person2, :title => "post3")		
		@posts = [@post1, @post2]
		render
	end	

	it "display button to create user account or to log in" do
		rendered.should =~ /Welcome/
		rendered.should have_button("Log in")
		rendered.should have_button("Create an account")
	end

	it "display a list of posts" do
		rendered.should =~ /#{@post1.title}/
		rendered.should =~ /#{@post2.title}/
	end

 	it "should not have a button named 'Add New Post' for creating a post" do
		rendered.should have_selector("input", :type => "submit", :name => "Add a new Post", :href => new_path) 
		rendered.should_not have_button("Add a new Post")
	end
	
	it "display 'Affichage d'une liste de Posts'" do
		rendered.should have_content('Post list display')
	end
	
	it "should display a button with 'id = post.id' to read each post" do
		@posts.each do |p|	
			rendered.should have_link("show_post#{p.id}", :href => show_path(p.id))
		end  	
	end
	  
	it "should not have a button Delete or Edit because without logging" do
	  	rendered.should_not have_button("Delete")
	  	rendered.should_not have_button("Edit")         		  	  	  	       		  	  	  	
	end
end

#------------------------------The User is logged----------------------------------------#

describe "post/index.html.erb" do
	before(:each) do	
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")
		@person2 = Person.create(:login => "mjordan", :password => "michjojo", :name => "jordan", :firstname => "michel", :id => "2")		
		@post1 = stub_model(Post, :person_id => @person1, :title => "post1")
		@post2 = stub_model(Post, :person_id => @person2, :title => "post2")
		@posts = [@post1, @post2]
		session[:id] = @person.id
		session[:firstname] = @person.firstname
		session[:name] = @person.name
		session[:login] = @person.login
		session[:password] = @person.password										
		render
	end	
	
	it "should have a button 'supprimer' by post if user logged is a owner" do
	  rendered.should have_button("Delete")  
		@posts.each do |p| 	
			if p.person_id = session[:id]
		 		rendered.should have_selector("input", :type => "submit", :href => delete_path(p.id))
		 	end
		end 		     		  	  	  	
	end		

	it "should display 'Welcome <%= session[:firstname] %>' if user logged" do
		rendered.should have_content("Welcome #{session[:firstname]}")
	end

  it "should have a button named 'Add a new Post' for create a post" do
		rendered.should have_selector("input", :type => "submit", :name => "Add a new Post", :href => new_path) 
		rendered.should have_button("Add a new Post")
	end
	
	it "display 'Affichage d'une liste de Posts'" do
		rendered.should have_content('Post list display')
	end
	
	it "should not display a window to permit the authentication if already logged" do
		rendered.should_not have_button('Log in')	
		rendered.should_not have_content('Login')
		rendered.should_not have_content('Password')
	end	
	
	it "should have a link 'Disconnect'" do
		rendered.should have_button("Disconnect")
	end	
	
	it "should have button 'My account'" do
		rendered.should have_button("My account")
	end
end
