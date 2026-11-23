require "test_helper"

class TodosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @todo = todos(:one)
    @other_user_todo = todos(:two)
    sign_in_as(@user)
  end

  test "should get index" do
    get todos_url
    assert_response :success
    assert_select "h3", text: @todo.title
    assert_select "h3", text: @other_user_todo.title, count: 0
  end

  test "should get show for own todo" do
    get todo_url(@todo)
    assert_response :success
    assert_select "h1", text: @todo.title
  end

  test "should not get show for another user's todo" do
    get todo_url(@other_user_todo)
    assert_response :not_found
  end

  test "should get new" do
    get new_todo_url
    assert_response :success
  end

  test "should create todo" do
    assert_difference("Todo.count") do
      post todos_url, params: { todo: { title: "New todo", description: "Details", status: "pending" } }
    end

    assert_redirected_to todos_url
    assert_equal @user, Todo.last.user
  end

  test "should not create todo with invalid attributes" do
    assert_no_difference("Todo.count") do
      post todos_url, params: { todo: { title: "", status: "pending" } }
    end

    assert_response :unprocessable_entity
  end

  test "should create todo owned by the current user only" do
    post todos_url, params: { todo: { title: "Scoped todo", status: "pending" } }

    assert_equal @user, Todo.find_by(title: "Scoped todo").user
  end

  test "should get edit for own todo" do
    get edit_todo_url(@todo)
    assert_response :success
  end

  test "should not get edit for another user's todo" do
    get edit_todo_url(@other_user_todo)
    assert_response :not_found
  end

  test "should update own todo" do
    patch todo_url(@todo), params: { todo: { title: "Updated title", status: "completed" } }

    assert_redirected_to todos_url
    @todo.reload
    assert_equal "Updated title", @todo.title
    assert_equal "completed", @todo.status
  end

  test "should not update own todo with invalid attributes" do
    patch todo_url(@todo), params: { todo: { title: "" } }

    assert_response :unprocessable_entity
    assert_equal "First todo", @todo.reload.title
  end

  test "should not update another user's todo" do
    assert_no_difference("Todo.count") do
      patch todo_url(@other_user_todo), params: { todo: { title: "Hacked" } }
    end

    assert_response :not_found
    assert_not_equal "Hacked", @other_user_todo.reload.title
  end

  test "should destroy own todo" do
    assert_difference("Todo.count", -1) do
      delete todo_url(@todo)
    end

    assert_redirected_to todos_url
  end

  test "should not destroy another user's todo" do
    assert_no_difference("Todo.count") do
      delete todo_url(@other_user_todo)
    end

    assert_response :not_found
    assert Todo.exists?(@other_user_todo.id)
  end

  test "should require authentication" do
    sign_out

    get todos_url
    assert_redirected_to new_session_url
  end
end
