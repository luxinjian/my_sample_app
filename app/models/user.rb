class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation

  has_secure_password
  before_save do
    |user| user.email.downcase!
    create_remember_token
  end

  has_many :microposts, dependent: :destroy
  has_many :relationships, dependent: :destroy, foreign_key: "follower_id"
  has_many :followed_users, through: :relationships, source: "followed"
  has_many :reverse_relationships, dependent: :destroy,
    foreign_key: :followed_id, class_name: "Relationship"
  has_many :followers, through: :reverse_relationships, source: :follower

  validates :name, presence: true, length: { maximum: 50 }
  EMAIL_FORMAT = /\A[\w+\-]+@[a-z\d\-]+\.[a-z]+\Z/i
  validates :email, presence: true, format: { with: EMAIL_FORMAT },
    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  def follow!(followed)
    relationships.create!(followed_id: followed.id)
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed.id).destroy
  end

  def following?(followed)
    relationships.find_by_followed_id(followed.id)
  end
end
