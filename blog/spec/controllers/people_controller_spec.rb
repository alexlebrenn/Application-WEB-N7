require 'spec_helper'

describe PeopleController do

#---------------------------------------------------------------------------------------#

	describe "POST 'create'" do
		before(:each) do
			@person = stub_model(Person, :login => "alebrenn", :name => "lebrenn", :firstname => "alex", :password => "zidane", :id => "10")
			@person = stub_model(Person)
			Person.stub(:new) {@person}
		end

		it "should create a new User with the given params" do
			Person.should_receive(:new)
			post :create, @new_person_params
		end

		it "should redirect to posts_path" do
			post :create, @new_person_params
			response.should be_success
	  	end
	end

#---------------------------------------------------------------------------------------#   

	describe "POST 'login'" do
		before(:each) do
			@person = stub_model(Person, :login => "mjordan", :name => "jordan", :firstname => "michel", :password => "mjordan", :id => "23")			
			Person.stub(:find_by_login_and_password).with(@person.login, @person.password)
		end
		
		it "should search the person" do
			Person.should_receive(:find_by_login_and_password).with(@person.login, @person.password).and_return(@pers)
			post :login, {:login => @person.login, :password => @person.password}		
			assigns(:person).should eq @pers
			assert_equal nil, session[:id]
		end
	end
		
	describe "POST 'login'" do		
		it "should unhautorize the authentication" do
			@person = stub_model(Person, :login => "mjordan", :name => "jordan", :firstname => "michel", :password => "mjordan", :id => "23")			
			Person.stub(:find_by_login).with(@person.login)
			post :login, :login => @person.login
			assigns(:person).should eq @pers	
			controller.session[:id] = @person.id
			assert_equal @person.id, session[:id]
		end
	end

#---------------------------------------------------------------------------------------#

	describe "GET 'logout'" do		
		before(:each) do
			@person = stub_model(Person, :login => "alebrenn", :name => "lebrenn", :firstname => "alex", :password => "zidane", :id => "10")
			session[:id]=@person.id	
			session[:name]=@person.name
			session[:firstname]=@person.firstname	
			session[:password]=@person.password
			session[:login]=@person.login
		end

		it "should logout the user and redirect_to posts_path" do
			get :logout, {:person_id => @person.id }
			response.should redirect_to posts_path			
		end
	end

#---------------------------------------------------------------------------------------#

	describe "GET 'show'" do
    before(:each) do
			@person = stub_model(Person, :login => "alebrenn", :name => "lebrenn", :firstname => "alex", :password => "zidane", :id => "10")
      Person.stub(:find){@person}
    end

    it "should search the person" do
      Person.should_receive(:find).with(@person.id.to_s).and_return(@person)
      get :show, {:person_id => @person.id }
    end
	end

#---------------------------------------------------------------------------------------#

	describe "PUT 'update'" do
		before(:each) do
			@person = stub_model(Person, :login => "alebrenn", :name => "lebrenn", :firstname => "alex", :password => "zidane", :id => "10")
      Person.stub(:find){@person}
		end

		it "modify the user account" do
			Person.should_receive(:find).and_return(@persreturn)	
			assigns(@person).should eq @persreturn			
			get "edit", {:person_id => @person.id}	
			put :update, {:person_id => @person.id}
			response.should be_success
		end
	end

#---------------------------------------------------------------------------------------#

	describe "DELETE 'delete'" do
    before(:each) do
			@person = stub_model(Person, :login => "alebrenn", :name => "lebrenn", :firstname => "alex", :password => "zidane", :id => "10")
      Person.stub(:find){@person}   
			@person.stub(:destroy){ true }
			session[:id] = @person.id
    end

    it "should search the person" do
      Person.should_receive(:find).with(@person.id.to_s).and_return(@person)
      delete :delete, {:person_id => @person.id }
    end

    it "should redirect to the posts list" do
      delete :delete, {:person_id => @person.id }
      response.should redirect_to posts_path
    end
	end

#---------------------------------------------------------------------------------------#       

end

