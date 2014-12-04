class Following < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :followee, class_name: 'User'
  
  validates :user_id, :followee_id, presence:true
  validates :user_id, uniqueness: { scope: [:followee_id] }
  validate :prevent_self_retweet
  
  def prevent_self_retweet
    errors.add(:base, "You cannot follow your self") if user_id == followee_id
  end

end
