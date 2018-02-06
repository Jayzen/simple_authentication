class Article < ApplicationRecord
  searchkick
  belongs_to :user
  belongs_to :category
  has_many :comments

  validates :title, presence: true
  validates :content, presence: true
  validates :category_id, presence: true

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]
  
  def should_generate_new_friendly_id?
    title_changed?
  end

  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize.to_s
  end
end
