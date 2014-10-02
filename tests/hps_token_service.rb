require 'net/http'

require 'rubygems'
require 'json'

module Hps
  class HpsTokenService
    attr_accessor :public_api_key, :url

    def initialize(public_api_key)
      @public_api_key = public_api_key
      if @public_api_key.nil? || @public_api_key.eql?('')
        raise HpsException.new('Public Key Not Found', '0')
      end

      components = @public_api_key.split '_'
      if components.size  < 3
        raise HpsException.new('Public API Key must contain at least two underscores','0')
      end

      if components[1].downcase.eql? 'prod'
        @url = 'https://api.heartlandportico.com/SecureSubmit.v1/api/token'
      else
        @url = 'https://posgateway.cert.secureexchange.net/Hps.Exchange.PosGateway.Hpf.v1/api/token'
      end

    end

    def get_token(card_data)
      data = {
          'api_key' => @public_api_key,
          'object' => 'token',
          'token_type' => 'supt',
          '_method' => 'post',
          'card[number]' => card_data.number,
          'card[cvv]' => card_data.cvv,
          'card[exp_month]' => card_data.exp_month,
          'card[exp_year]' => card_data.exp_year
      }
      get_result = get(data)
      JSON.parse(get_result)
    end

    def get(data)
      begin
        uri = URI(@url)
        uri.query = URI.encode_www_form(data)
        res = Net::HTTP.get_response(uri)
        res.body

      rescue Exception => e
        raise HpsException.new(e.message,'0')
      end
    end
  end
end