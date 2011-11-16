require 'spec_helper'

describe "post/new.html.erb" do
	it "create a new post" do
		render
		rendered.should have_content('Creation d\'un nouveau Post')
		rendered.should have_selector "form"
		rendered.should have_selector "input"
	end
end




