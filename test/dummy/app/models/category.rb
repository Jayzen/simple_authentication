class Category < ApplicationRecord
  has_ancestry orphan_strategy: :destroy
  before_validation :correct_ancestry
  
  validates :name, presence: { message: "标签名称不能为空" }
  validates :name, uniqueness: { message: "标签名称需唯一" }

  private
    def correct_ancestry
      self.ancestry = nil if self.ancestry.blank?
    end
end
