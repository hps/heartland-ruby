require 'hps'

module Hps
  module TestData

    # card holders

    def self.valid_cardholder
      result = HpsCardHolder.new()
      result.first_name = "Bill"
      result.last_name = "Johnson"
      result.address = HpsAddress.new
      result.address.address = "One Heartland Way"
      result.address.city = "Jeffersonville"
      result.address.state = "IN"
      result.address.zip = "47130"
      result.address.country = "United States"
      result
    end

    def self.cert_cardholder_shortzip
      result = HpsCardHolder.new()
      result.first_name = "Bill"
      result.last_name = "Johnson"
      result.address = HpsAddress.new
      result.address.address = "6860 Dallas Pkwy"
      result.address.city = "Irvine"
      result.address.state = "TX"
      result.address.zip = "75024"
      result.address.country = "United States"
      result
    end

    def self.cert_cardholder_shortzip_no_street
      result = HpsCardHolder.new()
      result.first_name = "Bill"
      result.last_name = "Johnson"
      result.address = HpsAddress.new
      result.address.city = "Irvine"
      result.address.state = "TX"
      result.address.zip = "75024"
      result.address.country = "United States"
      result
    end

    def self.cert_cardholder_longzip
      result = HpsCardHolder.new()
      result.first_name = "Bill"
      result.last_name = "Johnson"
      result.address = HpsAddress.new
      result.address.address = "6860 Dallas Pkwy"
      result.address.city = "Irvine"
      result.address.state = "TX"
      result.address.zip = "750241234"
      result.address.country = "United States"
      result
    end

    def self.cert_cardholder_longzip_no_street
      result = HpsCardHolder.new()
      result.first_name = "Bill"
      result.last_name = "Johnson"
      result.address = HpsAddress.new
      result.address.city = "Irvine"
      result.address.state = "TX"
      result.address.zip = "750241234"
      result.address.country = "United States"
      result
    end

    # credit cards

    def self.valid_visa
      result = HpsCreditCard.new
      result.cvv = 123
      result.exp_month = 12
      result.exp_year = 2025
      result.number = 4012002000060016
      result
    end

    def self.valid_mastercard
      result = HpsCreditCard.new
      result.cvv = 123
      result.exp_month = 12
      result.exp_year = 2025
      result.number = 5473500000000014
      result
    end

    def self.valid_discover
      result = HpsCreditCard.new
      result.cvv = 123
      result.exp_month = 12
      result.exp_year = 2025
      result.number = 6011000990156527
      result
    end

    def self.valid_amex
      result = HpsCreditCard.new
      result.cvv = 1234
      result.exp_month = 12
      result.exp_year = 2025
      result.number = 372700699251018
      result
    end

    def self.valid_jcb
      result = HpsCreditCard.new
      result.cvv = 123
      result.exp_month = 12
      result.exp_year = 2025
      result.number = 3566007770007321
      result
    end

    def self.invalid_card
      result = HpsCreditCard.new
      result.cvv = 123
      result.exp_month = 12
      result.exp_year = 2025
      result.number = 12345
      result
    end

    #  =============
    #  = Giftcards =
    #  =============
    TEST_CARD_NUMBERS = (6277200000000001..6277200000000099)

    def self.valid_gift_card_not_encrypted(random = true)
      return HpsGiftCard.new(Random.rand(TEST_CARD_NUMBERS)) if random
      return HpsGiftCard.new(TEST_CARD_NUMBERS.first) if !random
    end # valid_gift_card_not_encrypted

  end
end
