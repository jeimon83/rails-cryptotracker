# == Schema Information
#
# Table name: balances
#
#  id         :bigint           not null, primary key
#  amount     :decimal(, )
#  date       :date
#  location   :string
#  variation  :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_balances_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Balance < ApplicationRecord
  belongs_to :user

  EXCHANGE_NAME = 'Binance Exchange'.freeze

  def self.daily_final_balance
    User.all.each do |user|
      return true if user.balances.last&.date == Time.now.to_date

      total = 0
      query_string  = "recvWindow=20000&timestamp=#{DateTime.now.strftime('%Q')}"
      digest        = OpenSSL::Digest.new('sha256')
      signature     = OpenSSL::HMAC.hexdigest(digest, user.exchange.secret_key, query_string)
      account_url   = "#{ENV['BINANCE_MAINNET']}/api/v3/account?#{query_string}&signature=#{signature}"
      account_info  = HTTParty.get(account_url, headers: { 'X-MBX-APIKEY': user.exchange.api_key })
      account_info['balances'].each do |balance|
        next if balance['free'].to_f.zero?

        price = Coin.ticker_price(balance['asset'])
        total += (price.to_f * balance['free'].to_f)
      end

      variation = (total * 100) / user.balances.last.amount - 100 if user.balances.last.present?
      Balance.create(location: EXCHANGE_NAME, amount: (total || 0), date: Time.now.to_date, variation: (variation || 0), user: user)
    end
  end
end
