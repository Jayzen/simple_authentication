class User < ApplicationRecord
  include SimpleAuthentication::ModelAuthenticate
  
  model_authenticate
  
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  mount_uploader :avatar, AvatarUploader
  after_update :crop_avatar

  def crop_avatar
    avatar.recreate_versions! if crop_x.present?
  end

  before_save { self.email = email.downcase }
  before_create :create_activation_digest

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255}, uniqueness: { case_sensitive: false }
  validates :email, format: { with: VALID_EMAIL_REGEX }, unless: proc{ |user| user.email.blank? }
  validates :password, length: { minimum: 6 }, allow_nil: true
    
  has_secure_password

  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, foreign_key: :recipient_id
  
  has_many :likes
  has_many :topics, through: :likes, source: :article
  
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  def should_generate_new_friendly_id?
    name_changed?
  end
  
  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize.to_s
  end
end
