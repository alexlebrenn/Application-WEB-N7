class Post < ActiveRecord::Base

	has_many :comments, :dependent => :destroy
	belongs_to :person

  validates :title, :presence =>true, :length => { :minimum => 5, :maximum => 30 }
  validates :body, :presence =>true, :length => { :minimum => 5, :maximum => 500 }

end
