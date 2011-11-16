require 'spec_helper'

#-------------------------------------------------------------------------------#

describe "AffichageListePosts" do
	before(:each) do
		@post1 = Post.create(:title => "sujet1", :body => "bla bla")
		@post2 = Post.create(:title => "sujet2", :body => "bla bla")
		visit posts_path
	end

	describe "GET /posts" do
		it "generates a listing of posts" do
			#page.status.should be(200)
			page.body.should include(@post1.title)
			page.body.should include(@post2.title)
		end

		it "is a button to click" do
  		page.has_xpath?('//input[@id="Ajouter un nouveau Post"]')
			click_on('Ajouter un nouveau post')
			current_path.should == "/posts/new" 
		end
	end
end

#-------------------------------------------------------------------------------#

describe "CreationDePost" do
	before (:each) do
		visit posts_new_path
	end	

	describe "GET /posts/new" do
		it "verifyCurrentPath" do
			current_path.should == "/posts/new"
		end	

		it "verifyButtonValiderNewPost" do
			click_on('Valider')
		end

		it "verifyPresenceFormulaireAvecTitleEtBody" do
			page.should have_selector('form')
			page.should have_field('title')
			page.should have_field('body')
			page.should have_button('Valider')
		end

		it "Find_Fields_And_Creation_Of_A_Post" do
			fill_in('title', :with => 'Titre du Post1')
			fill_in('body', :with => 'Contenu du Post1')
			click_button ('Valider')
			current_path.should == "/posts"
			page.should have_content('Titre du Post1')
		end
	end

  describe "POST /posts" do
  	it "After Click go on posts/new" do
  	  fill_in('title', :with => 'Titre du Post2')
      fill_in('body', :with => 'Contenu du Post2')
      click_button('Valider')
      current_path.should == "/posts"
      end
  end
end

#-------------------------------------------------------------------------------#

describe "SuppressionDePost" do
  before (:each) do
  	@post1 = Post.create(:title => "Titre du Post1", :body => "Contenu du Post1")
    @post2 = Post.create(:title => "Titre du Post2", :body => "Contenu du Post2")
    visit posts_path
  end
  
	describe "DELETE /posts" do
	  it "verifyCurrentPath" do
	    current_path.should == "/posts"
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
	    current_path.should == "/posts"
      page.body.should include(@post1.title)
      page.body.should_not include(@post2.title)
    end   
  end
end 

#-------------------------------------------------------------------------------#

describe "ConsultationDePost" do
  before (:each) do
  	@post1 = Post.create(:title => "Titre du Post1", :body => "Contenu du Post1")
    @post2 = Post.create(:title => "Titre du Post2", :body => "Contenu du Post2")
    visit posts_path
  end

  describe "GET /posts/:id" do
    it "verifyCurrentPath" do
    	current_path.should == "/posts"
  	end   
  
  	it "generates a listing of posts" do
	  	page.body.should include(@post1.title)
    	page.body.should include(@post2.title)
  	end

  	it "verifyLinkPostPresence" do
    	page.should have_link("#{@post2.id}")
  	end

  	it "verifyAfterClick" do
    	click_link("#{@post2.id}")
    	current_path.should == "/posts/#{@post2.id}"
    	page.body.should include(@post2.title)
    	page.body.should include(@post2.body)
    	page.body.should_not include(@post1.title)
    	page.body.should_not include(@post1.title)
			page.should have_button('Page daccueil')
			click_button('Page daccueil')
			current_path.should == "/posts"                      
  	end   
  end
end

#-------------------------------------------------------------------------------#

describe "ModificationDePost" do
	before (:each) do
  	@post1 = Post.create(:title => "Titre du Post1", :body => "Contenu du Post1")
		visit posts_path
	end	

	describe "POST /posts/modify/:id" do
		it "verifyCurrentPath" do
			current_path.should == "/posts"
		end	

		it "verifyButtonModifierNewPost" do
			click_button('Modifier')
		end

		it "verifyafterclickModify" do
			click_button("Modifier")
      current_path.should == "/posts/modify/#{@post1.id}"
      page.body.should include(@post1.title)
      page.body.should include(@post1.body)
      fill_in('body', :with => 'Contenu modifie')
      click_button("Valider")                                
			current_path.should == "/posts/#{@post1.id}"
			page.should have_selector('form')
			page.should have_field('title')
			page.should have_field('body')
			page.should have_button('Page daccueil')
			page.should have_content("Contenu modifie")
    	page.should_not have_content("Contenu du Post1")
			click_button('Page daccueil')
			current_path.should == "/posts"
		end
  end
end

#-------------------------------------------------------------------------------#

