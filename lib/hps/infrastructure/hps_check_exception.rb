module Hps
  class HpsCheckException < HpsException
    attr_accessor :transaction_id,
                  :details,
                  :code

    def initialize(transaction_id, details, code, message = nil)
      @transaction_id = transaction_id
      @details = details
      super(message, code)
    end
  end
end
