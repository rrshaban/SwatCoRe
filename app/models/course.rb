class Course < ActiveRecord::Base
  has_many :reviews, dependent: :destroy
  has_one :professor
  has_one :department           # we can accept this for now
  
end
