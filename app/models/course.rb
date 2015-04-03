class Course < ActiveRecord::Base
  has_many :reviews, dependent: :destroy
  has_one :professor
  
end
