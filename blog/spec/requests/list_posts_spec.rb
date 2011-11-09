require 'spec_helper'

describe "PostListings" do
	before(:each) do
		@post1 = Post.create(:title => "sujet1", :body => "bla bla")
		@post2 = Post.create(:title => "sujet2", :body => "bla bla")
	end

	describe "GET /posts" do
		it "generates a listing of posts" do
		get posts_path
		response.status.should be(200)
		response.body.should include(@post1.title)
		response.body.should include(@post2.title)
		end
	end
end
