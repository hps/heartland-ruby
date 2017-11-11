module Hps
  class HpsGiftCardService < HpsService
    def activate(giftcard, amount, currency = "USD")
      HpsInputValidation.check_amount(amount)
      txn_type = "GiftCardActivate"

      xml = Builder::XmlMarkup.new
      xml.hps :Transaction do
        xml.hps txn_type.to_sym do
          xml.hps :Block1 do
            xml.hps :Amt, amount

            if giftcard.is_a? HpsTokenData
              card_data = HpsGiftCard.new
              card_data.token_value = giftcard.token_value
            else
              card_data = giftcard
            end

            hydrate_gift_card_data(giftcard, xml)
          end
        end
      end
      submit_transaction(xml.target!, txn_type)
    end # activate

    def add_value(giftcard, amount, currency = "USD")
      HpsInputValidation.check_amount(amount)
      txn_type = "GiftCardAddValue"

      xml = Builder::XmlMarkup.new
      xml.hps :Transaction do
        xml.hps txn_type.to_sym do
          xml.hps :Block1 do
            xml.hps :Amt, amount

            if giftcard.is_a? HpsTokenData
              card_data = HpsGiftCard.new
              card_data.token_value = giftcard.token_value
            else
              card_data = giftcard
            end

            hydrate_gift_card_data(giftcard, xml)
          end
        end
      end
      submit_transaction(xml.target!, txn_type)
    end # add_value

    def balance(giftcard)
      txn_type = "GiftCardBalance"

      xml = Builder::XmlMarkup.new
      xml.hps :Transaction do
        xml.hps txn_type.to_sym do
          xml.hps :Block1 do

            if giftcard.is_a? HpsTokenData
              card_data = HpsGiftCard.new
              card_data.token_value = giftcard.token_value
            else
              card_data = giftcard
            end

            hydrate_gift_card_data(giftcard, xml)
          end
        end
      end
      submit_transaction(xml.target!, txn_type)
    end # balance

    def deactivate(giftcard)
      txn_type = "GiftCardDeactivate"

      xml = Builder::XmlMarkup.new
      xml.hps :Transaction do
        xml.hps txn_type.to_sym do
          xml.hps :Block1 do

            if giftcard.is_a? HpsTokenData
              card_data = HpsGiftCard.new
              card_data.token_value = giftcard.token_value
            else
              card_data = giftcard
            end

            hydrate_gift_card_data(giftcard, xml)
          end
        end
      end
      submit_transaction(xml.target!, txn_type)
    end # deactivate

    def replace(old_card, new_card)
      txn_type = "GiftCardReplace"

      xml = Builder::XmlMarkup.new
      xml.hps :Transaction do
        xml.hps txn_type.to_sym do
          xml.hps :Block1 do

            hydrate_gift_card_data(old_card, xml, 'OldCardData')
            hydrate_gift_card_data(new_card, xml, 'NewCardData')

          end
        end
      end
      submit_transaction(xml.target!, txn_type)
    end # replace

    def reward(giftcard, amount, currency = "USD", gratuity = nil, tax = nil)
      HpsInputValidation.check_amount(amount)
      txn_type = "GiftCardReward"

      xml = Builder::XmlMarkup.new
      xml.hps :Transaction do
        xml.hps txn_type.to_sym do
          xml.hps :Block1 do
            xml.hps :Amt, amount

            if giftcard.is_a? HpsTokenData
              card_data = HpsGiftCard.new
              card_data.token_value = giftcard.token_value
            else
              card_data = giftcard
            end

            hydrate_gift_card_data(giftcard, xml)

            if ["USD", "POINTS"].include? currency.upcase
              xml.hps :Currency, currency.upcase
            end

            if gratuity
              xml.hps :GratuityAmtInfo, gratuity
            end

            if tax
              xml.hps :TaxAmtInfo, tax
            end

          end
        end
      end
      submit_transaction(xml.target!, txn_type)
    end # reward

    def sale(giftcard, amount, currency = "USD", gratuity = nil, tax = nil)
      HpsInputValidation.check_amount(amount)
      txn_type = "GiftCardSale"

      xml = Builder::XmlMarkup.new
      xml.hps :Transaction do
        xml.hps txn_type.to_sym do
          xml.hps :Block1 do
            xml.hps :Amt, amount

            if giftcard.is_a? HpsTokenData
              card_data = HpsGiftCard.new
              card_data.token_value = giftcard.token_value
            else
              card_data = giftcard
            end

            hydrate_gift_card_data(giftcard, xml)

            if ["USD", "POINTS"].include? currency.upcase
              xml.hps :Currency, currency.upcase
            end

            if gratuity
              xml.hps :GratuityAmtInfo, gratuity
            end

            if tax
              xml.hps :TaxAmtInfo, tax
            end

          end
        end
      end
      submit_transaction(xml.target!, txn_type)
    end # sale

    def void(txn_id)
      txn_type = "GiftCardVoid"

      xml = Builder::XmlMarkup.new
      xml.hps :Transaction do
        xml.hps txn_type.to_sym do
          xml.hps :Block1 do
            xml.hps :GatewayTxnId, txn_id
          end
        end
      end
      submit_transaction(xml.target!, txn_type)
    end # void

    def reverse(giftcard, amount)
      HpsInputValidation.check_amount(amount)
      txn_type = "GiftCardReversal"

      xml = Builder::XmlMarkup.new
      xml.hps :Transaction do
        xml.hps txn_type.to_sym do
          xml.hps :Block1 do
            xml.hps :Amt, amount

            if giftcard.is_a? HpsTokenData
              xml.hps :TokenValue, giftcard.token_value
            elsif giftcard.is_a? HpsGiftCard
              card_data = giftcard
              hydrate_gift_card_data(card_data, xml)
            else
              xml.hps :GatewayTxnId, giftcard
            end

          end
        end
      end
      submit_transaction(xml.target!, txn_type)
    end # reverse

    private
      def hydrate_gift_card_data(gift_card, xml, element_name = 'CardData')
        xml.hps element_name.to_sym do
          if gift_card.number
            xml.hps :CardNbr, gift_card.number
          elsif gift_card.track_data
            xml.hps :TrackData, gift_card.track_data
          elsif gift_card.alias
            xml.hps :Alias, gift_card.alias
          elsif gift_card.token_value
            xml.hps :TokenValue, gift_card.token_value
          end
        
          if gift_card.encryption_data
            hydrate_encryption_data(gift_card.encryption_data, xml)
          end

          if gift_card.pin
            xml.hps :PIN, gift_card.pin
          end
        end
      end # hydrate_gift_card_data

    def hydrate_encryption_data(encryption_data, xml)
      xml.hps :EncryptionData do
        if encryption_data.encrypted_track_number
          xml.hps :EncryptedTrackNumber, encryption_data.encrypted_track_number
        end
        xml.hps :KSN, encryption_data.ksn
        xml.hps :KTB, encryption_data.ktb
        xml.hps :Version, encryption_data.version
      end
    end # hydrate_encryption_data

    def submit_transaction(transaction, txn_type, client_txn_id = nil)
        response = doTransaction(transaction, client_txn_id)

        header = response['Header']
        transaction_response = response["Transaction"][txn_type]

        if !transaction_response["RspCode"].eql? "0"
          raise @exception_mapper.map_gift_card_exception(header["GatewayTxnId"], transaction_response["RspCode"], transaction_response["RspText"])
        end

        if !header["GatewayRspCode"].eql? "0"
          raise @exception_mapper.map_gateway_exception(header["GatewayTxnId"], header["GatewayRspCode"], header["GatewayRspMsg"])
        end

        rvalue = ''
        case txn_type
          when 'GiftCardActivate'
            rvalue = HpsGiftCardActivate::from_response(response, txn_type)
          when 'GiftCardAddValue'
            rvalue = HpsGiftCardAddValue::from_response(response, txn_type)
          when 'GiftCardAlias'
            rvalue = HpsGiftCardAlias::from_response(response, txn_type)
          when 'GiftCardBalance'
            rvalue = HpsGiftCardBalance::from_response(response, txn_type)
          when 'GiftCardDeactivate'
            rvalue = HpsGiftCardDeactivate::from_response(response, txn_type)
          when 'GiftCardReplace'
            rvalue = HpsGiftCardReplace::from_response(response, txn_type)
          when 'GiftCardReward'
            rvalue = HpsGiftCardReward::from_response(response, txn_type)
          when 'GiftCardSale'
            rvalue = HpsGiftCardSale::from_response(response, txn_type)
          when 'GiftCardVoid'
            rvalue = HpsGiftCardVoid::from_response(response, txn_type)
          when 'GiftCardReversal'
            rvalue = HpsGiftCardReversal::from_response(response, txn_type)
        end

        return rvalue;
    end # submit_transaction

  end # HpsGiftCardService
end # Hps