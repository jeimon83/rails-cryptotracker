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
      user = params[:user]
      current_user.update(firstname: user[:firstname], lastname: user[:lastname])
      Wallet.find_or_create_by(name: user[:wallet_name], address: user[:wallet_address], user: current_user)
      Exchange.find_or_create_by(name: user[:exchange_name], api_key: user[:exchange_api_key], secret_key: user[:exchange_secret_key], user: current_user)
      flash[:notice] = 'User updated'
      redirect_to edit_user_path(current_user)
    end
  end

  def destroy
  end
end
