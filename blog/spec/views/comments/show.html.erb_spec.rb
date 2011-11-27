require 'spec_helper'

describe "comments/show.html.erb" do
  before(:each) do
		@post = Post.create(:title => "Post11", :body => "bla bla")
		@comment = Comment.create(:author => "Alex", :body => "comment1", :id => 1, :post_id => @post.id)
  end

  it "displays the comment author with its body" do
    render

		rendered.should have_content('Affichage du commentaire')
		rendered.should have_content('Auteur :')
    rendered.should have_content("Contenu : ")
    rendered.should have_content("comment1")
		rendered.should have_selector("input",:type => "text", :name => "author")
    rendered.should have_selector("textarea", :name => "body")
		rendered.should have_button('Modifier')
		rendered.should have_button('Retour')
	end
end
