class Course < ActiveRecord::Base
  include ActionView::Helpers::DateHelper # for time_ago_in_words
  has_many :reviews, dependent: :destroy
  has_one :professor
  has_one :department           # we can accept this for now
  default_scope -> { order(crn: :asc) } ## cached_votes_score
 

  def prof
    Professor.find(self.professor_id)
  end

  def prof_name
    prof.name
  end

  def last
    time_ago_in_words(self.reviews.order('updated_at DESC')[0].updated_at)
  end

    # Professor.find(course)

end
