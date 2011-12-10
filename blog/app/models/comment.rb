class Comment < ActiveRecord::Base
	# on associe des coms à UN SEUL post.
	belongs_to :post
	belongs_to :person
  
  validates_presence_of :person_id, :post_id, :comment

  def author
    self.person
  end
end
