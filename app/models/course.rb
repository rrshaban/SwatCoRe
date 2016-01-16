class Course < ActiveRecord::Base
  include ActionView::Helpers::DateHelper # for time_ago_in_words
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TextHelper

  include PgSearch
  multisearchable :against => [:name, :crn, :description]

  # SYLLABUS PDF ATTACHMENT
  has_attached_file :syllabus, 
    :url => "/:attachment/:id/:basename.:extension",
    :path => ":rails_root/public/:attachment/:id/:basename.:extension",
    :styles => { :pdf_thumbnail => ["400x400>", :png]}
  validates_attachment :syllabus,
    :content_type => { :content_type => ["application/pdf","application/msword", 
             "application/vnd.openxmlformats-officedocument.wordprocessingml.document", 
             "text/plain"] }  # MUST BE PDF
    #:size => { :in => 0..1.megabytes }                        # MAX SIZE 1MB -- but it's breaking things :/
  before_post_process :syllabus

  # Serialize CRNs as an Array. 
  serialize :crn #, Array   # <- if we force this, we can't migrate from str->[]

  # MODEL HIERARCHY
  has_many :reviews, dependent: :destroy
  has_one :professor
  has_one :department           # we can accept this for now

  # MODEL ORDERING
  default_scope -> { order(crn: :asc) } ## cached_votes_score
 

  def prof
    Professor.find(self.professor_id)
  end

  def prof_path
    Rails.application.routes.url_helpers.professor_path(prof)
  end

  def prof_name
    ActionController::Base.helpers.link_to(prof.name, prof_path)
  end

  def prof_name_raw
    prof.name
  end

  def dept
    Department.find(self.department_id)
  end

  def dept_path
    Rails.application.routes.url_helpers.department_path(dept)
  end

  def dept_name
    ActionController::Base.helpers.link_to(dept.name, dept_path)
  end

  def last
    if self.reviews.any?
      pluralize(self.reviews.count, "review")
      # "Last reviewed " + time_ago_in_words(self.reviews.order('updated_at DESC')[0].updated_at) + " ago."
    else
      ""
    end
  end

  def avg
    if self.reviews.any?
      count = self.reviews.count
      clarity, intensity, worthit, votes, up = 0.0, 0.0, 0.0, 0, 0

      self.reviews.each { |r|
        clarity   +=  r.clarity.to_f
        intensity +=  r.intensity.to_f
        worthit   +=  r.worthit.to_f
        votes     +=  r.cached_votes_total
        up        +=  r.cached_votes_up
      }

      clarity   /= count
      intensity /= count
      worthit   /= count

      { clarity: clarity.round(1), 
        workload: intensity.round(1), 
        worthit: worthit.round(1),
        votes: votes,
        up:    up
      }
    else
      { clarity: "n/a", 
        workload: "n/a", 
        worthit: "n/a",
        votes: 0,
        up: 0
      }
    end
  end
  
end
