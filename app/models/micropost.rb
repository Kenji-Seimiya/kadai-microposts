class Micropost < ApplicationRecord
  has_many :favorites ,  dependent: :destroy
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 255 }
  
end
