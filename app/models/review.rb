class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  validates :user_id, presence: true
  validates :content, presence: true
end
