
class TodosController < ApplicationController
  before_action :require_authentication
  before_action :set_todo, only: [:show, :edit, :update, :destroy]

  def index
    @todos = current_user.todos
    @pending_todos = @todos.where(status: "pending")
    @completed_todos = @todos.where(status: "completed")
    @cancelled_todos = @todos.where(status: "cancelled")
  end

  def show
  end

  def new
    @todo = current_user.todos.new
  end

  def create
    @todo = current_user.todos.new(todo_params)

    if @todo.save
      redirect_to todos_path, notice: "Todo created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @todo.update(todo_params)
      redirect_to todos_path, notice: "Todo updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @todo.destroy
    redirect_to todos_path, notice: "Todo deleted!"
  end

  def complete
    @todo = current_user.todos.find(params[:id])
    @todo.update(status: "completed")
    redirect_to todos_path
  end

  def cancel
    @todo = current_user.todos.find(params[:id])
    @todo.update(status: "cancelled")
    redirect_to todos_path
  end

  def restore
    @todo = current_user.todos.find(params[:id])
    @todo.update(status: "pending")
    redirect_to todos_path
  end

  private

  def set_todo
    @todo = current_user.todos.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :status)
  end
end

