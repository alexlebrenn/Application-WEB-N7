require 'spec_helper'

describe "comments/edit.html.erb" do
  before(:each) do
		@post = Post.create(:title => "Post11", :body => "bla bla")
		@comment = Comment.create(:author => "Alex", :body => "comment1", :id => 1, :post_id => @post.id)
  end

  it "renders the edit comment form" do
    render

		rendered.should have_content('Modification du Commentaire')
		rendered.should have_content('Auteur :')
		rendered.should have_content('Contenu :')
    rendered.should have_content("comment1")
    rendered.should have_selector("form[method='post'][action='#{post_comment_path(@post, @comment)}']")
		rendered.should have_selector("input",:type => "text", :name => "author")
    rendered.should have_selector("textarea", :name => "body")
   	rendered.should have_selector("input", :type => "submit", :name => "Valider")
  end
end

