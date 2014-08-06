class User < ActiveRecord::Base
  attr_accessible :email, :password_digest
	has_secure_password
	attr_accessible :email, :password, :password_confirmation

  def admin?
    self.role == 'admin'
  end
  
	validates_uniqueness_of :email
end
