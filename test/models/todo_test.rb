require "test_helper"

class TodoTest < ActiveSupport::TestCase
  test "is valid with valid attributes" do
    todo = todos(:one)
    assert todo.valid?
  end

  test "requires a title" do
    todo = todos(:one)
    todo.title = nil
    assert_not todo.valid?
    assert_includes todo.errors[:title], "can't be blank"
  end

  test "requires a status included in the allowed list" do
    todo = todos(:one)
    todo.status = "unknown"
    assert_not todo.valid?
    assert_includes todo.errors[:status], "is not included in the list"
  end

  test "rejects a nil status" do
    todo = todos(:one)
    todo.status = nil
    assert_not todo.valid?
  end

  test "defaults to pending status" do
    todo = users(:one).todos.new(title: "Default status")
    assert_equal "pending", todo.status
    assert todo.valid?
  end

  test "belongs to a user" do
    todo = todos(:one)
    assert_equal users(:one), todo.user
  end

  test "is destroyed with its user" do
    user = users(:one)
    assert_difference("Todo.count", -user.todos.count) do
      user.destroy
    end
  end
end
