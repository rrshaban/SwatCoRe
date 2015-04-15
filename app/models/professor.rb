class Professor < ActiveRecord::Base
  has_many :courses
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
  
end

