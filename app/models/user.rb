class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation

  has_secure_password
  before_save do
    |user| user.email.downcase!
    create_remember_token
  end

  validates :name, presence: true, length: { maximum: 50 }
  EMAIL_FORMAT = /\A[\w+\-]+@[a-z\d\-]+\.[a-z]+\Z/i
  validates :email, presence: true, format: { with: EMAIL_FORMAT },
    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
