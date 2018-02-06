class Category < ApplicationRecord
  has_ancestry orphan_strategy: :destroy
  before_validation :correct_ancestry
  
  validates :name, presence: { message: "标签名称不能为空" }
  validates :name, uniqueness: { message: "标签名称需唯一" }

  has_many :articles, dependent: :destroy
  
  def self.grouped_data
    self.roots.order("weight desc").inject([]) do |result, parent|
      row = []
      row << parent
      row << parent.children.order("weight desc")
      result << row
    end
  end
 
  private
    def correct_ancestry
      self.ancestry = nil if self.ancestry.blank?
    end
end
