class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  default_scope -> { order(created_at: :desc) } ## NEWEST FIRST. TO BE CHANGED.
  validates :user_id, presence: true
  validates :course_id, presence: true
  validates :overall, presence: true
  validates :content, presence: true
end
