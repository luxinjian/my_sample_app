class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  default_scope order: "microposts.created_at DESC"

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  def self.from_users_followed_by(user)
    where("user_id in (select followed_id from relationships where
          follower_id = :user_id) or user_id = :user_id", user_id: user.id)
  end
end
