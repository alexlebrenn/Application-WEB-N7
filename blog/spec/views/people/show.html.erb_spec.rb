require 'spec_helper'

describe "people/show.html.erb" do
  before(:each) do
		@person = stub_model(Person, :name => "nom", :firstname => "prenom", :password => "Password", :login => "Login")
		session[:id] = @person.id 
		render
  end

	it "displays the title of the page" do
		rendered.should have_content('User Account')
	end

	it "displays parameters of a Person" do
		rendered.should have_content('Firstname :')
		rendered.should have_content('name :')
		rendered.should have_content('Login :')
		rendered.should have_content('Password :')
		rendered.should have_selector("input",:type => "text", :name => "firstname", :content => @person.firstname)
		rendered.should have_selector("input",:type => "text", :name => "name", :content => @person.name)
	end
	
	it "should have textfield for parameters of a Person" do
		rendered.should have_selector("input",:type => "text", :name => "nom")
		rendered.should have_selector("input",:type => "text", :firstname => "prenom")
		rendered.should have_selector("input",:type => "text", :password => "Password")        
		rendered.should have_selector("input",:type => "text", :login => "Login")
	end

	it "should have a button to modify user account" do
		rendered.should have_selector("input", :type => "submit", :name => "Edit", :href => edit_person_path(@person.id)) 
		rendered.should have_button("Edit")
	end

	it "should have a button to delete user account" do
		rendered.should have_selector("input", :type => "submit", :name => "Delete", :href => posts_path) 
		rendered.should have_button("Delete")
	end

	it "should have a button to back to the Home Page" do
		rendered.should have_selector("input", :type => "submit", :name => "Home Page", :href => posts_path) 
		rendered.should have_button("Home Page")
	end	
end
