class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :microposts
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  has_many :like_relationships, dependent: :destroy
  has_many :likes, through: :like_relationships, source: :like
  has_many :reverses_of_relationship, class_name: 'LikeRelationship', foreign_key: 'like_id'
  
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def like(other_content)
      self.like_relationships.find_or_create_by(like_id: other_content.id)
  end

  def unlike(other_content)
    like_relationship = self.like_relationships.find_by(like_id: other_content.id)
    like_relationship.destroy if like_relationship
  end
  
  def likes?(other_content)
    self.likes.include?(other_content)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
end