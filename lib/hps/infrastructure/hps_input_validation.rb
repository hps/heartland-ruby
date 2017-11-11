module Hps
  class HpsInputValidation
    def self.check_amount(amount)
      if amount < 0 || amount == nil
        raise InvalidRequestException
      end

      return amount if amount.is_a? Float

      amount.gsub(/[^0-9\.]/, '')
    end
  end
end
