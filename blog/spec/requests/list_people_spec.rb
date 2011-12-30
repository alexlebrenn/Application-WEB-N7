require 'spec_helper'

#-------------------------------------------------------------------------------#

describe "UserAccountCreation" do
	before (:each) do
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")	
		visit posts_path
	end
	
	describe "GET /people/new" do	
		it "verifyCurrentPath" do
			current_path.should == posts_path
			page.should have_button('Create an account')
			click_on('Create an account')
			current_path.should == new_person_path	
		end	
		
		it "verifyPresenceFormulaireAvecTitleEtBody" do
			visit new_person_path
			page.should have_selector('form')
			page.should have_field('firstname')
			page.should have_field('name')
			page.should have_field('login')
			page.should have_field('password')
			page.should have_button('Create')
			page.should have_button('Home Page')			
		end
		
		it "filling Fields And Create User Account" do
			visit new_person_path
			fill_in('firstname', :with => 'rails')			
			fill_in('name', :with => 'rubyman')
			fill_in('login', :with => 'rubyrails')
			fill_in('password', :with => 'railsforever')					
			click_button('Create')
			current_path.should == posts_path
			page.should have_content("User was successfully created.")
		end

		it "verify click button back to Home Page" do
			visit new_person_path
			page.should have_button('Home Page')	
			click_button('Home Page')
			current_path.should == posts_path		
		end			
	end
end

#-------------------------------------------------------------------------------#

describe "UserIsLoging" do
	before (:each) do
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")	
   	visit posts_path
		visit login_person_path
	end
		
	it "should display a form with login and password fields" do
		page.should have_selector('form')
		page.should have_field('login')
		page.should have_content("Login :")			
		page.should have_field('password')	
		page.should have_content("Password :")
		page.should have_button("Login")
	end	
	
	it "should log the user '@person1.login' with password '@person1.password' and redirect to posts_path" do
		fill_in('login', :with => @person.login)
		fill_in('password', :with => @person.password)
		click_button("Login")
		current_path.should == posts_path
		page.should have_content("Authentication is successful !")
		page.should have_content("Welcome #{@person.firstname}")
	end		
end

#-------------------------------------------------------------------------------#

describe "UserIsLogingOut" do
	before (:each) do
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")	
   	visit posts_path
		visit login_person_path
		fill_in('login', :with => @person.login)
		fill_in('password', :with => @person.password)
		click_button("Login")		
	end

	it "should display buttons 'My account' and 'Disconnect' and a message 'Welcome '@person.firstname'" do
		current_path.should == posts_path
		page.should have_content("Welcome #{@person.firstname}")
		page.should have_button("My account")						
		page.should have_button("Disconnect")						
	end		
	
	it "should logout after clicking button 'Disconnect'" do
		click_button("Disconnect")	
		current_path.should == posts_path		
		page.should have_content("Successful disconnection !")
		page.should_not have_button("My account")						
		page.should_not have_button("Disconnect")					
	end		

end

#-------------------------------------------------------------------------------#

describe "UserAccountConsultation" do
  before (:each) do
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")	
    visit posts_path
		visit login_person_path
		fill_in('login', :with => @person.login)
		fill_in('password', :with => @person.password)
		click_button ('Login')
  end

 	it "should display buttons 'My account' and 'Disconnect' and a message 'Welcome '@person.firstname'" do
		current_path.should == posts_path
		page.should have_content("Welcome #{@person.firstname}")
		page.should have_button("My account")						
		page.should have_button("Disconnect")						
	end		  
  
  it "verify click button My account" do
		click_button ('My account')
		current_path.should == show_person_path(@person.id)
  end

	it "should display a form with login and password fields" do
		visit show_person_path(@person.id)
		page.should have_selector('form')
		page.should have_content("Firstname :")
		page.body.should include(@person.firstname)
		page.should have_content("Name :")
		page.body.should include(@person.name)	
		page.should have_content("Login :")
		page.body.should include(@person.login)
		page.should have_content("Password :")
		page.body.should include(@person.password)
		page.should have_button("Edit")
		page.should have_button("Delete")
		page.should have_button("Home Page")
	end

 	it "verify click back to Home Page" do
		visit show_person_path(@person.id)
		page.should have_button('Home Page')	
		click_button('Home Page')
		current_path.should == posts_path		
	end	
end

#-------------------------------------------------------------------------------#

describe "UserAccountModification" do
  before (:each) do
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")	
    visit posts_path
		visit login_person_path
		fill_in('login', :with => @person.login)
		fill_in('password', :with => @person.password)
		click_button ('Login')
  end

	it "should display a form with login and password fields" do
		visit show_person_path(@person.id)
		page.should have_selector('form')
		page.should have_content("Firstname :")
		page.body.should include(@person.firstname)
		page.should have_content("Name :")
		page.body.should include(@person.name)	
		page.should have_content("Login :")
		page.body.should include(@person.login)
		page.should have_content("Password :")
		page.body.should include(@person.password)
		page.should have_button("Edit")
		page.should have_button("Delete")
		page.should have_button("Home Page")
	end 	

  it "verify click button Edit" do
		visit show_person_path(@person.id)
		click_button ('Edit')
		current_path.should == edit_person_path(@person.id)
  end

	it "verifyafterclickModify" do
		visit edit_person_path(@person.id)	
		page.body.should include(@person.firstname)
		page.body.should include(@person.name)
		page.body.should include(@person.login)	
		page.body.should include(@person.password)
    fill_in('login', :with => 'Contenu modifie')
		click_button("Modify")                                
		current_path.should == show_person_path(@person.id)
		page.should have_selector('form')
		page.should have_content("Firstname :")
		page.should have_field('login')
		page.should have_content("User account was successfully updated !")
    page.should_not have_content("alebrenn")
		page.should have_button('Home Page')	
		click_button('Home Page')
		current_path.should == posts_path		
	end		  
end

#-------------------------------------------------------------------------------#

describe "UserAccountSuppression" do
  before (:each) do
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")	
    visit posts_path
		visit login_person_path
		fill_in('login', :with => @person.login)
		fill_in('password', :with => @person.password)
		click_button ('Login')
  end

	it "should display a form with login and password fields" do
		visit show_person_path(@person.id)
		page.should have_selector('form')
		page.should have_content("Firstname :")
		page.body.should include(@person.firstname)
		page.should have_content("Name :")
		page.body.should include(@person.name)	
		page.should have_content("Login :")
		page.body.should include(@person.login)
		page.should have_content("Password :")
		page.body.should include(@person.password)
		page.should have_button("Edit")
		page.should have_button("Delete")
		page.should have_button("Home Page")
	end 	

  it "verify click button Delete" do
		visit show_person_path(@person.id)
		page.should have_button("Delete")
		click_button ('Delete')
		current_path.should == posts_path
		page.should have_content("User account was successfully destroyed !")
		page.should_not have_content("Welcome #{@person.firstname}")
		page.should_not have_button("My account")						
		page.should_not have_button("Disconnect")
		page.should have_button("Log in")						
  end
end

#-------------------------------------------------------------------------------#
