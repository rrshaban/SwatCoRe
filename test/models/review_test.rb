require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:razi)
    @course = courses(:cs21)
    @review = @course.reviews.new(content: "Lorem Ipsum", overall: 5, user_id: @user.id)
  end

  test "should be valid" do
    assert @review.valid?
  end

  test "user id should be present" do
    @review.user_id = nil
    assert_not @review.valid?
  end

  test "course id should be present" do
    @review.course_id = nil
    assert_not @review.valid?
  end

  test "overall rating should be present" do
    @review.overall = nil
    assert_not @review.valid?
  end

  test "content should be present " do
    @review.content = "   "
    assert_not @review.valid?
  end

  test "order should be most recent first" do
    assert_equal Review.first, reviews(:most_recent)
  end
end
