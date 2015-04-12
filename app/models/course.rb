class Course < ActiveRecord::Base
  include ActionView::Helpers::DateHelper # for time_ago_in_words
  # include ActionController::Base.helpers.link_to
  include Rails.application.routes.url_helpers

  # include Rails.application.routes.url_helpers
  has_many :reviews, dependent: :destroy
  has_one :professor
  has_one :department           # we can accept this for now
  default_scope -> { order(crn: :asc) } ## cached_votes_score
 

  def prof
    Professor.find(self.professor_id)
  end

  def prof_path
    Rails.application.routes.url_helpers.professors_path(prof)
  end

  def prof_name
    ActionController::Base.helpers.link_to(prof.name, prof_path)
  end

  def dept
    Department.find(self.department_id)
  end

  def dept_path
    Rails.application.routes.url_helpers.departments_path(dept)
  end

  def dept_name
    ActionController::Base.helpers.link_to(dept.name, dept_path)
  end

  def last
    if self.reviews.any?
      "Last reviewed " + time_ago_in_words(self.reviews.order('updated_at DESC')[0].updated_at) + " ago."
    else
      "No reviews yet — you could be the first!"
    end
  end


  def avg
    { clarity: 5, workload: 5, worthit: 5 }
  end
  
end
