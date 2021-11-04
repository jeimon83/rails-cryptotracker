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
#
class Balance < ApplicationRecord

  def self.daily_final_balance
    return true if Balance.last&.date == Time.now.to_date

    total = 0
    query_string  = "recvWindow=20000&timestamp=#{DateTime.now.strftime('%Q')}"
    digest        = OpenSSL::Digest.new('sha256')
    signature     = OpenSSL::HMAC.hexdigest(digest, ENV['BINANCE_SECRET_KEY'], query_string)    
    account_url   = "#{ENV['BINANCE_MAINNET']}/api/v3/account?#{query_string}&signature=#{signature}"
    account_info  = HTTParty.get(account_url, headers: { 'X-MBX-APIKEY': ENV['BINANCE_API_KEY'] })
    account_info['balances'].each do |balance|
      next if balance['free'].to_f == 0

      price = Coin.ticker_price(balance['asset'])
      
      total = total + (price.to_f * balance['free'].to_f)
    end

    last_balance_amount =  if Balance.last.present?
      Balance.last.amount
    else
      total
    end

    Balance.create(location: 'Binance Exchange', amount: total, date: Time.now.to_date, variation: ((total*100)/last_balance_amount - 100))
  end
end
