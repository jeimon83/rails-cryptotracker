require 'openssl'

class StaticPagesController < ApplicationController
  def home
  end

  def ethereum_network
    @balance = Rails.cache.fetch("ethereum_network_#{current_user.wallet.address}", expires_in: 5.minutes) do
      web3 = Web3::Eth::Rpc.new(
        host: ENV['INFURA_MAINNET'],
        port: 443,
        connect_options: {
          open_timeout: 20,
          read_timeout: 140,
          use_ssl: true,
          rpc_path: "/v3/#{ENV['INFURA_API_KEY']}"
        }
      )

      web3.eth.getBalance("#{current_user.wallet.address}")
    end
  end

  def binance_exchange
    @spot_wallet = Rails.cache.fetch("binance_exchange_#{current_user.exchange.api_key}", expires_in: 5.minutes) do
      # Binance::Api.ping!
      query_string  = "recvWindow=20000&timestamp=#{DateTime.now.strftime('%Q')}"
      digest        = OpenSSL::Digest.new('sha256')
      signature     = OpenSSL::HMAC.hexdigest(digest, current_user.exchange.secret_key, query_string)    
      spot_url      = "#{ENV['BINANCE_MAINNET']}/sapi/v1/capital/config/getall?#{query_string}&signature=#{signature}"
      
      HTTParty.get(spot_url, headers: { 'X-MBX-APIKEY': current_user.exchange.api_key })
    end
  end

  def binance_smart_chain
    @bsc_balance = Rails.cache.fetch("binance_smart_chain_#{current_user.wallet.address}", expires_in: 5.minutes) do
      bsc_url = "#{ENV['BSC_MAINNET']}?module=account&action=balance&address=#{current_user.wallet.address}&apikey=#{ENV['BSC_API_KEY']}"

      HTTParty.get(bsc_url)
    end
  end

  def help; end

  def contact; end

  private
end
