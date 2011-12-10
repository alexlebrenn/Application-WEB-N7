class Post < ActiveRecord::Base

	has_many :comments, :dependent => :destroy
	belongs_to :person

  validates_presence_of :title, :body
  validates_length_of :title, :maximum => 30
  validates_length_of :body, :maximum => 500
  
  #has_and_belongs_to_many :people
end
