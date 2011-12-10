require 'spec_helper'

describe "comments/new.html.erb" do
  before(:each) do
		@post = Post.create(:title => "Post11", :body => "bla bla")
		@comment = Comment.create(:author => "Alex", :body => "comment1", :id => 1, :post_id => @post.id)
  end

	it "displays a form to create a new comment" do
		render
		rendered.should =~ /author/
		rendered.should =~ /body/

		rendered.should have_content('Ajout d\'un commentaire')
		rendered.should have_content('Auteur')
		rendered.should have_content('Contenu')
		rendered.should have_selector("form", :method => "POST")
		rendered.should have_selector("input",:type => "text", :name => "author")
    rendered.should have_selector("textarea", :name => "body")
   	rendered.should have_selector("input", :type => "submit", :name => "Create Comment")
		rendered.should have_button('Retour')
	end
end
