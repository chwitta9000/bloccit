class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  attr_accessible :body, :post

  after_create :send_favorite_emails

  default_scope order('updated_at DESC')

  def send_favorite_emails
    self.post.favorites.each do |favorite|

      if favorite.user_id != self.user_id && favorite.user.email_favorites?
        FavoriteMailer.new_comment(favorite.user, self.post, self).deliver
      end
    end
  end

  validates :body, length: {minimum: 2}, presence: true
  validates :user, presence: true
end
