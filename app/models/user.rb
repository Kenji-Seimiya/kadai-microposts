class User < ApplicationRecord
  before_save {self.email.downcase! }
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  has_many :microposts
  
  has_many :relationships, dependent: :destroy
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationship, dependent: :destroy, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationship, source: :user
  
  has_many :favorites
  has_many :fav_posts, through: :favorites, source: :micropost
  
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
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  def add_likes(micropost)
    self.favorites.find_or_create_by(micropost_id: micropost.id)
    
  end
  
  def rem_likes(micropost)
    favorite = self.favorites.find_by(micropost_id: micropost.id)
    favorite.destroy if favorite
  end 
  
  def now_likes?(micropost)
    self.fav_posts.include?(micropost)
  end
end
