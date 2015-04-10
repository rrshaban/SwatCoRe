class Professor < ActiveRecord::Base
  has_many :courses
  has_one  :department
  has_many :reviews,  through: :courses

  def dept_name
    Department.find(self.department_id).name
  end
  
end

