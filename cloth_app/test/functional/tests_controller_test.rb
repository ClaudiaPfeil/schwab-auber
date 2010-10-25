require File.dirname(__FILE__) + '/../test_helper'
require 'tests_controller'

# Re-raise errors caught by the controller.
class TestsController; def rescue_action(e) raise e end; end

class TestsControllerTest < ActionController::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :tests

  def test_should_allow_signup
    assert_difference 'Test.count' do
      create_test
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'Test.count' do
      create_test(:login => nil)
      assert assigns(:test).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'Test.count' do
      create_test(:password => nil)
      assert assigns(:test).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'Test.count' do
      create_test(:password_confirmation => nil)
      assert assigns(:test).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference 'Test.count' do
      create_test(:email => nil)
      assert assigns(:test).errors.on(:email)
      assert_response :success
    end
  end
  

  

  protected
    def create_test(options = {})
      post :create, :test => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
    end
end
