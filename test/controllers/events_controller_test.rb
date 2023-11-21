require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  test "should get create_event_a" do
    get :create_event_a
    assert_response :success
  end

  test "should get create_event_b" do
    get :create_event_b
    assert_response :success
  end

  test "should get search_and_notify" do
    get :search_and_notify
    assert_response :success
  end

end
