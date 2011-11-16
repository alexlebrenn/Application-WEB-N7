require 'spec_helper'

describe "post/index.html.erb" do
	it "displays all the posts" do
		@post1 = stub_model(Post, :title => "sujet1")
		@post2 = stub_model(Post, :title => "sujet2")
		assign(:posts, [@post1, @post2])

		render
		rendered.should =~ /sujet1/
		rendered.should =~ /sujet2/

		rendered.should have_selector "ul li"
		rendered.should have_selector "li:contains('#{@post1.title}')"
		rendered.should have_selector "li:contains('#{@post2.title}')"		
	end
end

