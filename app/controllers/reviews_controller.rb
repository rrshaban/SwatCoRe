class ReviewsController < ApplicationController
  # before_action :logged_in_user
  
  
  def create

    @course = Course.find(review_params[:course_id])

    p = review_params
    p[:user_id] = current_user.id    # this is a hack

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
      params.require(:review).permit(:content,
                                    :clarity,
                                    :intensity,
                                    :worthit,
                                    :professor_id,
                                    :department_id,
                                    :course_id,
                                    :id)
    end

end
