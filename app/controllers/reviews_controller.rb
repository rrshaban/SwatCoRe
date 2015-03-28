class ReviewsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  
  
  def create

    @course = Course.find(params[:course_id])

    p = review_params
    p[:user_id] = @current_user.id    # this is a hack

    @review = @course.reviews.build(p)

    if @review.save
      flash[:success] = "Review created!"
    else
      flash[:error] = "Error creating review."
    end
    redirect_to course_path(id: @course)
  end

  def destroy
  end

  private

    def review_params
      params.require(:review).permit(:content,:overall,:id,:course_id)
    end

end
