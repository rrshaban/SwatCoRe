class Review < ActiveRecord::Base
  acts_as_votable

  # before_create :logged_in_user
  # after_create :timestamp_user
  belongs_to :user
  belongs_to :course
  # default_scope -> { order(cached_votes_score: :desc, cached_votes_up: :desc) } ## cached_votes_score
  
  validates :user_id, presence: true
  validates :content, presence: true
  validates :clarity, presence: true
  validates :intensity, presence: true
  validates :worthit, presence: true
  validates :professor_id, presence: true
  validates :department_id, presence: true
  validates :course_id, presence: true

  has_one :professor
  has_one :department


  def like(user)
    self.liked_by user
  end

  def dislike(user)
    self.liked_by user
  end

  def user_name
    User.find(self.user_id).name
  end


  # Should update user's timestamp whenever they post a review
  # can't get @current_user, it's not in params
  # private
  #   def timestamp_user
  # #     @current_user = User.find(params[:user_id])

  # #     @current_user.update_attribute(:updated_at, Time.now)
  #   end
end