class Person < ActiveRecord::Base

  validates :firstname, :presence =>true
  validates :name, :presence =>true
	validates :login, :presence =>true, :uniqueness=>true, :length => { :minimum => 5, :maximum => 20 }
  validates :password, :presence =>true, :length => { :minimum => 5, :maximum => 20 }	

	has_many :posts
	has_many :comments

  def self.authenticate(login, password)
    person = self.find_by_login_and_password(login, password)
  end
end
