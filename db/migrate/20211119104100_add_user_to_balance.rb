class AddUserToBalance < ActiveRecord::Migration[6.1]
  def change
    add_reference :balances, :user, foreign_key: true
  end
end
