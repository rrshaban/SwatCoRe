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

  def dept
    Department.find(self.department_id)
  end

  def dept_name
    dept.name
  end

  def last
    if self.reviews.any?
      "Last reviewed " + time_ago_in_words(self.reviews.order('updated_at DESC')[0].updated_at) + " ago."
    else
      "No reviews yet — you could be the first!"
    end
  end
  
end
