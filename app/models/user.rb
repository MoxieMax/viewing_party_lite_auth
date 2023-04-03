class User < ApplicationRecord
  
  validates_presence_of :name, 
                        :email,
                        :password_digest
  
  validates :email, uniqueness: true
  
  has_many :party_users
  has_many :parties, through: :party_users
  has_secure_password
  
end