class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  acts_as_voter
  has_many :reviews, dependent: :destroy
  

  validates_format_of :email, :with => /\A[a-z]*\d*@(swarthmore|haverford|brynmawr).edu\z/i

  def avg
    if self.reviews.any?
      count = self.reviews.count
      clarity, intensity, worthit = 0.0, 0.0, 0.0

      self.reviews.each { |r|
        clarity   +=  r.clarity.to_f
        intensity +=  r.intensity.to_f
        worthit   +=  r.worthit.to_f
      }

      clarity   /= count
      intensity /= count
      worthit   /= count

      { clarity: clarity.round(1), 
        workload: intensity.round(1), 
        worthit: worthit.round(1) 
      }
    else
      { clarity: "n/a", 
        workload: "n/a", 
        worthit: "n/a" 
      }
    end
  end


  protected
    def confirmation_required?
      true
    end
end
