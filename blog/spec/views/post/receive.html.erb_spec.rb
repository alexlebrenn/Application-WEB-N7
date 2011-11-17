require 'spec_helper'

describe "/post/receive.html.erb" do
  before(:each) do
    assigns[:post] = @post = stub_model(Post, :id => 1, :title => "value for title", :body => "value for body")
  end

  it "renders the edit post form" do
    render

		rendered.should have_content('Modification du Post')
		rendered.should have_content('Titre du Post')
		rendered.should have_content('Message')
    rendered.should have_selector("form[method='post'][action='#{show_path(@post.id)}']")
		rendered.should have_selector("input",:type => "text", :name => "title")
    rendered.should have_selector("textarea", :name => "body")
   	rendered.should have_selector("input", :type => "submit", :name => "Valider")
  end
end

