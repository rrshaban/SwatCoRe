require 'test_helper'

class ReviewTest < ActiveSupport::TestCase

  def setup
    @user = users(:razi)
    # code is bad below
    @review = @course.review.build(content: "Lorem ipsum", user_id: @user.id)
  end

  test "should be valid" do
    assert @review.valid?
  end

  test "user id should be present" do
    @review.user_id = nil
    assert_not @review.valid?
  end


  test "content should be present " do
    @review.content = "   "
    assert_not @review.valid?
  end

end
