class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:edit, :update, :destroy]

  
  def edit
  end

  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review.course, notice: 'Review was successfully updated.' }
        format.json { render :show, status: :ok, location: @review.course }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  def create

    @course = Course.find(review_params[:course_id])

    p = review_params
    p[:user_id] = current_user.id    # this is a hack

    @review = @course.reviews.build(p)

    if @review.save
      flash[:success] = "Review created!"
    else
      flash[:error] = "Error creating review. Review must contain some text."
    end

    redirect_to course_path(id: @course)
  end

  def destroy
    course = @review.course
    @review.destroy
    respond_to do |format|
      format.html { redirect_to course, notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
    end
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

    def set_review
      @review = Review.find(params[:id])
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
