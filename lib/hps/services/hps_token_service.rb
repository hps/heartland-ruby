require 'net/http'

require 'rubygems'
require 'json'

module Hps
  class HpsTokenService < HpsService

    def tokenize_card(card)
      xml = Builder::XmlMarkup.new
      xml.hps :Transaction do
        xml.hps :Tokenize do
          xml.hps :Block1 do
            xml.hps :CardData do
              xml.hps :ManualEntry do
                xml.hps :CardNbr, card.number
                xml.hps :ExpMonth, card.exp_month
                xml.hps :ExpYear, card.exp_year
                xml.hps :CVV2, card.cvv
                xml.hps :CardPresent, card.card_present ? "Y" : "N"
                xml.hps :ReaderPresent, card.reader_present ? "Y" : "N"
              end
              xml.hps :TokenRequest, 'Y'
            end
          end
        end
      end

      tokenize(xml.target!)
    end

    def tokenize(transaction)
      response = doTransaction(transaction)

      response
    end

  end
end


# initiate token service client
#
# client = Hps::HpsTokenService.new("skapi_cert_MUeyBQAX128AlmCXpiY3kknHjlU6fN0iGFBpP7uGsQ") < this is my secret api key from heartland (non-prod)
#
# create card with card info
#
# card = Hps::HpsCreditCard.new
# card.number = '4111111111111111'
# card.cvv = '123'
# card.exp_month = '02'
# card.exp_year = '2023'
#
# client.tokenize_card(card)
