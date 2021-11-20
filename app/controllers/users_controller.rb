class UsersController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
    if params.present? && params[:commit] == 'Save'
      current_user.update_info(params[:user]) 
      flash[:notice] = 'User updated'
      redirect_to edit_user_path(current_user)
    end
  end

  def destroy
  end
end
