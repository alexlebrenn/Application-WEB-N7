class Comment < ActiveRecord::Base
	# on associe des coms à UN SEUL post.
	belongs_to :post
end
