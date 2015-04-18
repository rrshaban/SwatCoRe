class Department < ActiveRecord::Base
  has_many :courses
  has_many :reviews,  through: :courses
  has_many :professors #, through: :courses # nope

  make_flaggable
end
