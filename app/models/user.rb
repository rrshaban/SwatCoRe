class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  acts_as_voter
  has_many :reviews, dependent: :destroy

  # # Let's not make users searchable yet either
  # include PgSearch
  # multisearchable :against => [:name]
  

  validates_format_of :email, :with => /\A[a-z]*\d*@(swarthmore|haverford|brynmawr).edu\z/i

  def karma
    avg[:score]
  end

  def avg
    if self.reviews.any?
      count = self.reviews.count
      clarity, intensity, worthit, votes, up, score = 0.0, 0.0, 0.0, 0, 0, 0

      self.reviews.each { |r|
        clarity   +=  r.clarity.to_f
        intensity +=  r.intensity.to_f
        worthit   +=  r.worthit.to_f
        votes     +=  r.cached_votes_total
        up        +=  r.cached_votes_up
        score     +=  r.cached_votes_score
      }

      clarity   /= count
      intensity /= count
      worthit   /= count

      { clarity: clarity.round(1), 
        workload: intensity.round(1), 
        worthit: worthit.round(1),
        votes: votes,
        up:    up,
        score: score
      }
    else
      { clarity: "n/a", 
        workload: "n/a", 
        worthit: "n/a",
        votes: 0,
        up: 0,
        score: 0
      }
    end
  end


  protected
    def confirmation_required?
      true
    end
end
