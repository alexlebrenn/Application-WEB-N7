require 'spec_helper'

describe "post/new.html.erb" do
	it "displays a form to create a new post" do
    newpost = mock_model("Post", :title => "title", :body => "body").as_new_record
    assign(:post, newpost)

		render
		rendered.should =~ /title/
		rendered.should =~ /body/

		rendered.should have_content('Creation d\'un nouveau Post')
		rendered.should have_content('Titre du Post')
		rendered.should have_content('Message')
		rendered.should have_selector("form", :method => "POST")
		rendered.should have_selector("input",:type => "text", :name => "title")
    rendered.should have_selector("textarea", :name => "body")
   	rendered.should have_selector("input", :type => "submit", :name => "Valider")
	end
end
