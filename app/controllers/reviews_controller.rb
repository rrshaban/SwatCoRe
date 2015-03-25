class ReviewsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  
  
  def create

    @review = @course.reviews.build(review_params)
    if @review.save
      flash[:success] = "Review created!"
      redirect_to course_path(id: @course)
    else
      redirect_to course_path
    end
  end

  def destroy
  end

  private

    def review_params
      params.require(:review).permit(:content,:overall,:user_id,:course_id,)
    end

end
