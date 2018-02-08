class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user
  validates :content, presence: true
  after_create :create_notifications


  private
    def create_notifications
      @recipient = self.article.user
      Notification.create(recipient: @recipient, actor: self.user, action: 'posted', notifiable: self)
    end
end
