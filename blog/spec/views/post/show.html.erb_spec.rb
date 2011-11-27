require 'spec_helper'

describe "post/show.html.erb" do
  before(:each) do
    @post = assign(:post, stub_model(Post, :title => "Titre", :body=>"Contenu"))
    @comment = assign(:comment, stub_model(Comment, :author => "Alex", :body=>"Commentaire", :post_id => @post))
  end

  it "displays the post with its title and body and its comment with author and body" do
    render

		rendered.should have_content('Affichage du Post')
		rendered.should have_content('Titre du Post')
		rendered.should have_content('Message')
    rendered.should have_content("Titre")
    rendered.should have_content("Contenu")
		rendered.should have_selector("input",:type => "text", :name => "title")
    rendered.should have_selector("textarea", :name => "body")
		rendered.should have_content('Commentaires')
		rendered.should have_content('Auteur :')
    rendered.should have_content("Contenu : ")
    rendered.should have_content("Commentaire1")
		rendered.should have_selector("input",:type => "text", :name => "author")
    rendered.should have_selector("textarea", :name => "body")
		rendered.should have_link('Modifier')
		rendered.should have_link('Supprimer')
		rendered.should have_button('Ajouter un commentaire')
		rendered.should have_button('Page daccueil')
	end
end
