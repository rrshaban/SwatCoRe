require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  def setup
    @user       = users(:razi)
    @other_user = users(:archer)
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_redirected_to root_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch :update, id: @other_user, user: { password:              FILL_IN,
                                            password_confirmation: FILL_IN,
                                            admin: FILL_IN }
    assert_not @other_user.FILL_IN.admin?
  end

end
