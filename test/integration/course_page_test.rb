require 'test_helper'

class CoursePageTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:razi)
    @course = courses(:cs21)
  end

  test "course display" do 
    get course_path(@course)
    assert_template 'courses/show'
    assert_select 'title', full_title(@course.name)
    assert_select 'h1', text: @course.name
    assert_match @course.reviews.count.to_s, response.body
    # assert_select 'div.pagination'
    @course.reviews.paginate(page: 1).each do |review|
      assert_match review.content, response.body
    end
  end
    
end
