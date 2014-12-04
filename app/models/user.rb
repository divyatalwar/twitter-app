class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :followings, dependent: :destroy
  has_many :followees, through: :followings
  has_many :reverse_follows, class_name: "Following", foreign_key: 'followee_id'
  has_many :followers, through: :reverse_follows, source: :user
  has_many :tweets, dependent: :destroy
  has_many :posts, through: :tweets
  
  validates :email, :lastname, :firstname, :username, presence: true
  validates :email, format: { with: EMAIL_FORMAT }
  validates :email, :username, uniqueness: true, :case_sensitive => false
  validates :firstname, uniqueness: { scope: [:lastname] }

  scope :except, ->(user) { where.not(id: user) }

  def to_param
    "#{username}".parameterize
  end

  def timeline
    users = followees + [self]
    Tweet.by_users(users).eager_loading_associations
  end

end
