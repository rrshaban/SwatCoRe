class Professor < ActiveRecord::Base
  has_many :courses
  has_one  :department
  has_many :reviews,  through: :courses
end

