class ReviewsController < ApplicationController
  before_action :user_id
  
  
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

    def user_id
      current_user = User.find(session["warden.user.user.key"][0][0])
    end
  

    def review_params
      params.require(:review).permit(:review_id,
                                    :content,
                                    :clarity,
                                    :intensity,
                                    :worthit,
                                    :professor_id,
                                    :department_id,
                                    :course_id,
                                    :id)
    end

end
