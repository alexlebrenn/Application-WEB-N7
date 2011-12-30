require 'spec_helper'

describe "people/new.html.erb" do
  before(:each) do
		@person = stub_model(Person, :name => "nom", :firstname => "prenom", :password => "Password", :login => "Login")
		render
  end

	it "displays the title of the page" do
		rendered.should have_content('Creating a new User Account')
	end

	it "displays parameters of a Person" do
		rendered.should have_content('Firstname :')
		rendered.should have_content('name :')
		rendered.should have_content('Login :')
		rendered.should have_content('Password :')
	end
	
	it "should display a form with method post" do        
		rendered.should have_selector("form", :method => "POST")
	end
	
	it "should have textfield for parameters of a Person" do
		rendered.should have_selector("input",:type => "text", :name => "nom")
		rendered.should have_selector("input",:type => "text", :firstname => "prenom")
		rendered.should have_selector("input",:type => "text", :password => "Password")        
		rendered.should have_selector("input",:type => "text", :login => "Login")
	end

	it "should have a button to create user account" do
		rendered.should have_selector("input", :type => "submit", :name => "Create", :href => create_person_path) 
		rendered.should have_button("Create")
	end

	it "should have a button to back to the Home Page" do
		rendered.should have_selector("input", :type => "submit", :name => "Home Page", :href => posts_path) 
		rendered.should have_button("Home Page")
	end	
end
