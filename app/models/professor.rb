class Professor < ActiveRecord::Base
  has_many :courses, dependent: :destroy
  has_one  :department
  has_many :reviews,  through: :courses

  def dept
    Department.find(self.department_id)
  end

  def dept_path
    Rails.application.routes.url_helpers.department_path(dept)
  end

  def dept_name
    ActionController::Base.helpers.link_to(dept.name, dept_path)
  end

  def avg
    if self.reviews.any?
      count = self.reviews.count
      clarity, intensity, worthit = 0.0, 0.0, 0.0

      self.reviews.each { |r|
        clarity   +=  r.clarity.to_f
        intensity +=  r.intensity.to_f
        worthit   +=  r.worthit.to_f
      }

      clarity   /= count        # divides sum by count to generate average
      intensity /= count
      worthit   /= count

      { clarity:  clarity.round(1),   # rounds to one decimal place
        workload: intensity.round(1), 
        worthit:  worthit.round(1) 
      }
    else
      { clarity: "n/a", 
        workload: "n/a", 
        worthit: "n/a" 
      }
    end
  end
  
end

