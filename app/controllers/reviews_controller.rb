class ReviewsController < ApplicationController
  # before_action :user_id

  
  
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

  def upvote
    @review = Review.find(params[:format])
    @review.liked_by current_user
    redirect_to(:back)
  end

  def downvote
    @review = Review.find(params[:format])
    @review.disliked_by current_user
    redirect_to(:back)
  end

  private

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
