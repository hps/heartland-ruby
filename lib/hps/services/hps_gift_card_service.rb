module Hps
  class HpsGiftCardService < HpsService
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
    end # balance

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

    # public function _hydrateEncryptionData(HpsEncryptionData $encryptionData, DOMDocument $xml)
    # {
    #     $encData = $xml->createElement('hps:EncryptionData');
    #     if ($encryptionData->encryptedTrackNumber != null) {
    #         $encData->appendChild($xml->createElement('hps:EncryptedTrackNumber', $encryptionData->encryptedTrackNumber));
    #     }
    #     $encData->appendChild($xml->createElement('hps:KSN', $encryptionData->ksn));
    #     $encData->appendChild($xml->createElement('hps:KTB', $encryptionData->ktb));
    #     $encData->appendChild($xml->createElement('hps:Version', $encryptionData->version));
    #     return $encData;
    # }

  end # HpsGiftCardService
end # Hps