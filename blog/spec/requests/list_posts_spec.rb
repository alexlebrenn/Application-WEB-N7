require 'spec_helper'

#-------------------------------------------------------------------------------#

describe "AffichageListePosts" do
	before(:each) do
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")	
		@post1 = Post.create(:title => "sujet1", :body => "bla bla")
		@post2 = Post.create(:title => "sujet2", :body => "bla bla")
		visit posts_path
		visit login_person_path
		fill_in('login', :with => @person.login)
		fill_in('password', :with => @person.password)
		click_button ('Login')
	end

	describe "GET /posts" do
		it "generates a listing of posts" do
			page.body.should include(@post1.title)
			page.body.should include(@post2.title)
		end

		it "is a button to click" do
  		page.has_xpath?('//input[@id="Add a new Post"]')
			click_on('Add a new Post')
			current_path.should == new_path 
		end
	end
end

#-------------------------------------------------------------------------------#

describe "CreationDePost" do
	before (:each) do
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")	
		visit posts_path
		visit login_person_path
		fill_in('login', :with => @person.login)
		fill_in('password', :with => @person.password)
		click_button ('Login')
		visit new_path
	end	

	describe "GET /posts/new" do
		it "verifyCurrentPath" do
			current_path.should == new_path
		end	

		it "verifyButtonValiderNewPost" do
			click_on('Create')
		end

		it "verifyPresenceFormulaireAvecTitleEtBody" do
			page.should have_selector('form')
			page.should have_field('author_post')
			page.should have_field('title')
			page.should have_field('body')
			page.should have_button('Create')
		end

		it "verify click back to home page" do
			visit new_path
			current_path.should == new_path
			page.should have_button('Home Page')	
			click_button('Home Page')
			current_path.should == posts_path		
		end		
	end

  describe "POST /posts" do
		it "verifyCurrentPath" do
			current_path.should == new_path
		end

		it "Find_Fields_And_Creation_Of_A_Post" do
			fill_in('author_post', :with => @person.login)
			fill_in('title', :with => 'Titre du Post1')
			fill_in('body', :with => 'Contenu du Post1')
			click_button ('Create')
			current_path.should == posts_path
			page.should have_content('Titre du Post1')
		end
  end
end

#-------------------------------------------------------------------------------#

describe "SuppressionDePost" do
  before (:each) do
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")	
  	@post1 = Post.create(:person_id => @person.id, :title => "Titre du Post1", :body => "Contenu du Post1")
    @post2 = Post.create(:person_id => @person.id, :title => "Titre du Post2", :body => "Contenu du Post2")
    visit posts_path
		visit login_person_path
		fill_in('login', :with => @person.login)
		fill_in('password', :with => @person.password)
		click_button ('Login')
  end
  
	describe "DELETE /posts" do
		it "verifyCurrentPath" do
			current_path.should == posts_path
		end	

		it "generates a listing of posts" do
			page.body.should include(@post1.title)
			page.body.should include(@post2.title)
		end

		it "verifyClickButtonDeletePresence" do
			page.should have_button("#{@post2.id}")
		end

		it "verifyAfterClick" do
			click_button("#{@post2.id}")
			current_path.should == posts_path
			page.body.should include(@post1.title)
			page.body.should_not include(@post2.title)
		end		
	end
end	

#-------------------------------------------------------------------------------#

describe "ConsultationDePost" do
  before (:each) do
		@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")	
  	@post1 = Post.create(:person_id => @person.id, :title => "Titre du Post1", :body => "Contenu du Post1")
    @post2 = Post.create(:person_id => @person.id, :title => "Titre du Post2", :body => "Contenu du Post2")
    visit posts_path
		visit login_person_path
		fill_in('login', :with => @person.login)
		fill_in('password', :with => @person.password)
		click_button ('Login')
  end

  describe "GET /posts/:id" do
    it "verifyCurrentPath" do
    	current_path.should == posts_path
  	end   
  
  	it "generates a listing of posts" do
	  	page.body.should include(@post1.title)
    	page.body.should include(@post2.title)
  	end

  	it "verifyLinkPostPresence" do
    	page.should have_link("show_post#{@post2.id}")
  	end

  	it "verifyAfterClick" do
    	click_link("show_post#{@post2.id}")
    	current_path.should == show_path(@post2.id)
    	page.body.should include(@post2.title)
    	page.body.should include(@post2.body)
    	page.body.should_not include(@post1.title)
    	page.body.should_not include(@post1.title)
	 	end
		
		it "verify click back to Home Page" do
			click_link("show_post#{@post2.id}")
    	current_path.should == "/posts/#{@post2.id}"
			page.should have_button('Home Page')	
			click_button('Home Page')
			current_path.should == posts_path		
		end	
  end
end

#-------------------------------------------------------------------------------#

describe "ModificationDePost" do
	before (:each) do
  	@person = Person.create(:login => "alebrenn", :password => "zidane", :name => "lebrenn", :firstname => "alex", :id => "1")	
  	@post = Post.create(:person_id => @person.id, :title => "Titre du Post1", :body => "Contenu du Post1")
    visit posts_path
		visit login_person_path
		fill_in('login', :with => @person.login)
		fill_in('password', :with => @person.password)
		click_button ('Login')
	end	

	describe "POST /posts/modify/:id" do
		it "verifyCurrentPath" do
			current_path.should == posts_path
		end	

		it "verifyButtonModifierNewPost" do
			page.should have_button("modify_post#{@post.id}")
		end

		it "verifyafterclickModify" do
			click_button("modify_post#{@post.id}")
      current_path.should == receive_path(@post.id)
      page.body.should include(@post.title)
      page.body.should include(@post.body)
      fill_in('body', :with => 'Contenu modifie')
      click_button("Modify")                                
			current_path.should == show_path(@post.id)
			page.should have_selector('form')
			page.should have_field('title')
			page.should have_field('body')
			page.should have_button('Home Page')
			page.should have_content("Post was successfully updated.")
    	page.should_not have_content("Contenu du Post1")
			click_button('Home Page')
			current_path.should == posts_path
		end
  end
end

#-------------------------------------------------------------------------------#

