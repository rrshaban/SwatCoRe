class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  acts_as_voter

  validates_format_of :email, :with => /\A[a-z]*\d*@(swarthmore|haverford|brynmawr).edu\z/i


  protected
    def confirmation_required?
      true
    end
end
