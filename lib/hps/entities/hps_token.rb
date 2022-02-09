module Hps
  class HpsTokenData

    attr_accessor :token_value, :response_code, :response_message

    def initialize(api_key, card)
      @card = card
    end



  end
end