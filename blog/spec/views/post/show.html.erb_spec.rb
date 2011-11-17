require 'spec_helper'

describe "post/show.html.erb" do
  before(:each) do
    @post = assign(:post, stub_model(Post, :title => "Titre", :body=>"Contenu"))
  end

  it "displays the post title with its body" do
    render

		rendered.should have_content('Affichage du Post')
		rendered.should have_content('Titre du Post')
		rendered.should have_content('Message')
    rendered.should have_content("Titre")
    rendered.should have_content("Contenu")
		rendered.should have_selector("input",:type => "text", :name => "title")
    rendered.should have_selector("textarea", :name => "body")
		rendered.should have_button('Page daccueil')
	end
end
