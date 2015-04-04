class Review < ActiveRecord::Base
  # before_create :logged_in_user
  after_create :timestamp_user
  belongs_to :user
  belongs_to :course
  default_scope -> { order(created_at: :desc) } ## NEWEST FIRST. TO BE CHANGED.
  validates :user_id, presence: true
  validates :course_id, presence: true  
  validates :content, presence: true

  has_one :professor
  has_one :department

  # Should update user's timestamp whenever they post a review
  # can't get @current_user, it's not in params
  # private
    def timestamp_user
  #     @current_user = User.find(params[:user_id])

  #     @current_user.update_attribute(:updated_at, Time.now)
    end
end
