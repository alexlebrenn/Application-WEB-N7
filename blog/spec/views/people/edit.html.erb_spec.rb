require 'spec_helper'

describe "people/edit.html.erb" do
  before(:each) do
		@person = stub_model(Person, :name => "nom", :firstname => "prenom", :password => "Password", :login => "Login")
		session[:id] = @person.id 
		render
  end

	it "displays the title of the page" do
		rendered.should have_content('Modification of User Account')
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
		rendered.should have_selector("input", :type => "submit", :name => "Modify", :href => show_person_path(@person.id)) 
		rendered.should have_button("Modify")
	end
end
