class User < ApplicationRecord
  include SimpleAuthentication::ModelAuthenticate
  model_authenticate
  mount_uploader :portrait, PortraitUploader

  before_save { self.email = email.downcase }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255}, uniqueness: { case_sensitive: false }
  validates :email, format: { with: VALID_EMAIL_REGEX }, unless: proc{ |user| user.email.blank? }
  validates :password, presence: true
  validates :password, length: { minimum: 6 }, unless: proc{ |user| user.password.blank? } 
    
  has_secure_password
end
