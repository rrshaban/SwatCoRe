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

  def upvote
    @review = Review.find(params[:id])
    respond_to do |format|
      unless current_user.voted_for? @review
        format.html { redirect_to :back }
        format.json { head :no_content }
        format.js { render :layout => false }
        @review.vote_total = @review.vote_total + 1
        @review.save
        @review.upvote_by current_user
      else
        flash[:danger] = 'You already voted this on review.'
        format.html { redirect_to :back }
        format.json { head :no_content }
        format.js
      end
    end
  end

  def downvote
    @review = Review.find(params[:review_id])
    respond_to do |format|
    unless current_user.voted_for? @review
      format.html { redirect_to :back }
      format.json { head :no_content }
      format.js { render :layout => false }
      @review.vote_total = @review.vote_total + 1
      @review.save
      @review.downvote_by current_user
    else
      flash[:danger] = 'You already voted on this review.'
      format.html { redirect_to :back }
      format.json { head :no_content }
      format.js
    end
   end
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
