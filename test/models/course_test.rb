require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = User.new(name: "Example User", email: "user@swarthmore.edu",
                      password: "foobar", password_confirmation: "foobar")
    @course = courses(:cs21)
  end

  test "associated reviews should be destroyed" do
    @user.save
    @course.reviews.create!(content: "Lorem ipsum", overall: 3, user_id: @user.id)
    assert_difference 'Review.count', -1 do
      @course.destroy
    end
  end
end
