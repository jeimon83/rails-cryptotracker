class Coin
  class << self
    def ticker_price(symbol)
      return '1.00' if symbol == 'USDT'
      
      Rails.cache.fetch("coin_#{symbol}", expires_in: 30.seconds) do
        ticker_url  = "#{ENV['BINANCE_MAINNET']}/api/v3/ticker/price?symbol=#{symbol}USDT"
        coin = HTTParty.get(ticker_url, headers: { 'X-MBX-APIKEY': ENV['BINANCE_API_KEY'] })
        coin['price']
      end
    end
  end
end