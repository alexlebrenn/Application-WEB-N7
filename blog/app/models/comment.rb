class Comment < ActiveRecord::Base

	belongs_to :post
  
  validates :post_id, :presence =>true
  validates :author, :presence =>true, :length => { :minimum => 3, :maximum => 30 }
  validates :body, :presence =>true, :length => { :minimum => 5, :maximum => 500 }
	#validates :rating, :presence =>true

end
