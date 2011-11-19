class Post < ActiveRecord::Base
	# Un ou plusieurs commentaires pour 1 post.
	has_many :comments
	#validates_presence_of :title
end

