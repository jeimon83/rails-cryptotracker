# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  firstname              :string
#  lastname               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :wallet
  has_one :exchange
  has_many :balances

  def create_or_update_wallet(wallet_attr)
    return wallet.update(wallet_attr) if wallet.present?
    
    wallet.create(wallet_attr)
  end

  def create_or_update_exchange(exchange_attr)
    return exchange.update(exchange_attr) if exchange.present?
    
    exchange.create(exchange_attr)
  end

  def update_info(data)
    update(firstname: data[:firstname], lastname: data[:lastname])
    create_or_update_wallet({ name: data[:wallet_name], address: data[:wallet_address] })
    create_or_update_exchange({ name: data[:exchange_name], api_key: data[:exchange_api_key], secret_key: data[:exchange_secret_key] })
  end
end
